//
//  ContentView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/20/21.
//

import SwiftUI
import MapKit
import CoreData

final class ContentViewModel: ObservableObject {
    @Published var mapType: String
    @Published var newPlaceLocation: CLLocationCoordinate2D?
    @Published var currentLocation: CLLocationCoordinate2D?
    
    @Published var showList: Bool = false
    @Published var index: Int?
    @Published var selectedIndex: Int?
    
    init(mapType: String) {
        self.mapType = mapType
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.createDate, ascending: true)],
        predicate: NSPredicate(format: "name.length > 0", ""),
        animation: .default)
    var places: FetchedResults<Place>
    @ObservedObject var viewModel: ContentViewModel
    
    var currentPlace: Place? {
        guard let index = viewModel.index else { return nil }
        return places[index]
    }
    
    init(mapType: String) {
        viewModel = .init(mapType: mapType)
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .black
        UISegmentedControl.appearance().backgroundColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapView(mapType: $viewModel.mapType,
                        newPlaceLocation: $viewModel.newPlaceLocation,
                        index: $viewModel.index,
                        selectedIndex: $viewModel.selectedIndex,
                        places: places).ignoresSafeArea()
                SelectView(mapType: $viewModel.mapType,
                           count: places.count,
                           index: $viewModel.index).frame(height: 64)
                if viewModel.showList {
                    ListView(places: places,
                             index: $viewModel.index,
                             showList: $viewModel.showList)
                        .environment(\.managedObjectContext, viewContext)
                }
                if viewModel.newPlaceLocation != nil {
                    AlertControlView(newLocationCoordinate: $viewModel.newPlaceLocation) { title, description in addPlace(title: title, description: description) }
                }
                if let selectedIndex = viewModel.selectedIndex {
                    NavigationLink(
                        destination: EditView(place: places[selectedIndex], completion: { newPlace in
                            changePlace(newPlace: newPlace)
                        }),
                        isActive: .constant(viewModel.selectedIndex != nil),
                        label: { Text("Cancel") }).hidden()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(currentPlace?.name ?? "")
            .toolbar {
                Button(action: { viewModel.showList.toggle() }) { Image(systemName: viewModel.showList ? "map" : "folder") }
            }
        }
    }
    
    func changePlace(newPlace: Place?) {
        viewModel.index = viewModel.selectedIndex
        viewModel.selectedIndex = nil
        guard let newPlace = newPlace else { return }
        newPlace.objectWillChange.send()
        try? self.viewContext.save()
    }
    
    func addPlace(title: String, description: String) {
        guard let coordinate = viewModel.newPlaceLocation else { return }
        let newPlace = Place(context: viewContext)
        newPlace.id = UUID().uuidString
        newPlace.latitude = coordinate.latitude
        newPlace.longitude = coordinate.longitude
        newPlace.name = title
        newPlace.createDate = Date()
        newPlace.message = description
        viewModel.newPlaceLocation = nil
        withAnimation {
            try? viewContext.save()
        }
        viewModel.index = places.firstIndex(of: newPlace) ?? 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mapType: "Normal")
    }
}

extension Place {
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        .init(latitude: .init(self.latitude), longitude: .init(self.longitude))
    }
    
    override public class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String>{
        let keyPaths = super.keyPathsForValuesAffectingValue(forKey: key)
        switch key {
        case "coordinate":
            return keyPaths.union(Set(["latitude","longitude"]))
        default:
            return keyPaths
        }
    }
}

//
//  ContentView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/20/21.
//

import SwiftUI
import MapKit
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.createDate, ascending: true)],
        predicate: NSPredicate(format: "name.length > 0", ""),
        animation: .default)
    private var places: FetchedResults<Place>
    @State var mapType: String
    @State var newPlaceLocation: CLLocationCoordinate2D?
    @State var currentLocation: CLLocationCoordinate2D?
    @State var selectedLocation: CLLocationCoordinate2D?
    
    @State var title: String?
    @State var description: String?
    @State var showList: Bool = false
    
    private var selectedPlace: Place? {
        places.first(where: {$0.latitude == selectedLocation?.latitude && $0.longitude == selectedLocation?.longitude })
    }
    
    private var currentPlace: Place? {
        places.first(where: {$0.latitude == currentLocation?.latitude && $0.longitude == currentLocation?.longitude })
    }
    
    init(mapType: String) {
        _mapType = State(initialValue: mapType)
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .black
        UISegmentedControl.appearance().backgroundColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapView(mapType: $mapType,
                        newPlaceLocation: $newPlaceLocation,
                        selectedLocation: $selectedLocation,
                        currentLocation: $currentLocation,
                        places: places)
                    .ignoresSafeArea()
                SelectView(mapType: $mapType,
                           places: places,
                           currentLocation: $currentLocation)
                    .frame(height: 64)
                if showList {
                    ListView(places: places,
                             currentLocation: $currentLocation,
                             showList: $showList)
                        .environment(\.managedObjectContext, viewContext)
                }
                if newPlaceLocation != nil {
                    AlertControlView(newLocation: $newPlaceLocation,
                                     name: $title,
                                     description: $description) { title, description in
                        addPlace()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(currentPlace?.name ?? "")
            .toolbar {
                Button(action: { showList.toggle() }) {
                    Image(systemName: showList ? "map" : "folder")
                }
            }
        }
    }
    
    private func addPlace() {
        guard let coordinate = $newPlaceLocation.wrappedValue,
              let titleText = $title.wrappedValue,
              let descriptionText = $description.wrappedValue else { return }
        let newPlace = Place(context: viewContext)
        newPlace.id = UUID().uuidString
        newPlace.latitude = coordinate.latitude
        newPlace.longitude = coordinate.longitude
        newPlace.name = titleText
        newPlace.createDate = Date()
        newPlace.message = descriptionText
        withAnimation {
            try? viewContext.save()
        }
        currentLocation = newPlaceLocation
        newPlaceLocation = nil
        title = nil
        description = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mapType: "Normal")
    }
}

extension Place {
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        return .init(latitude: .init(self.latitude),
                     longitude: .init(self.longitude))
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

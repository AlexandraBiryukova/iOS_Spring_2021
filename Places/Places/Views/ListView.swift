//
//  ListView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/21/21.
//

import Foundation
import MapKit
import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding private var currentLocation: CLLocationCoordinate2D?
    @Binding private var showList: Bool
    var places: FetchedResults<Place>
    
    init(places: FetchedResults<Place>,
         currentLocation: Binding<CLLocationCoordinate2D?>?,
         showList: Binding<Bool>) {
        self.places = places
        self._currentLocation = currentLocation ?? Binding.constant(nil)
        self._showList = showList
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableHeaderView = nil
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    @ViewBuilder
    var listView: some View {
        if places.isEmpty {
            VStack {
                Text("No places")
                    .padding(.top, 24)
                Spacer()
            }
        } else {
            List {
                ForEach(places, id: \.self) { place in
                    ZStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(place.name ?? "")
                                    .multilineTextAlignment(.leading)
                                    .font(.init(.system(size: 16, weight: .bold, design: .default)))
                                Text(place.message ?? "")
                                    .multilineTextAlignment(.leading)
                                    .font(.init(.system(size: 14, weight: .regular, design: .default)))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showList = false
                        currentLocation = place.coordinate
                    }
                    .listRowBackground(Color.clear)
                }.onDelete(perform: { indexSet in
                    deletePlaces(offsets: indexSet)
                })
            }
        }
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .edgesIgnoringSafeArea(.all)
            listView
                .edgesIgnoringSafeArea(.horizontal)
        }
    }
    
    private func deletePlaces(offsets: IndexSet) {
        withAnimation {
            offsets.map { places[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

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
    
    @Binding private var index: Int?
    @Binding private var showList: Bool
    
    var places: FetchedResults<Place>
    
    init(places: FetchedResults<Place>,
         index: Binding<Int?>,
         showList: Binding<Bool>) {
        self.places = places
        self._index = index 
        self._showList = showList
        
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableHeaderView = nil
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    @ViewBuilder
    var listView: some View {
        if places.isEmpty {
            VStack {
                Text("No places").padding(.top, 24)
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
                    .onTapGesture(count: 1) {
                        showList = false
                        index = places.firstIndex(of: place)
                    }
                    .listRowBackground(Color.clear)
                }.onDelete(perform: { indexSet in deletePlaces(offsets: indexSet) })
            }
        }
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light)).edgesIgnoringSafeArea(.all)
            listView.edgesIgnoringSafeArea(.horizontal)
        }
    }
    
    private func deletePlaces(offsets: IndexSet) {
        if offsets.first == index {
            index = nil
        }
        withAnimation {
            offsets.map { places[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

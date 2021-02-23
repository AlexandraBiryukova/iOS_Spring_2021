//
//  SelectView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/21/21.
//

import Foundation
import MapKit
import SwiftUI

struct SelectView: View {
    @Binding var mapType: String
    @Binding var currentLocation: CLLocationCoordinate2D?
    @State private var index = 0 {
        didSet {
            guard index >= 0 else {
                index = places.count - 1
                return
            }
            guard index < places.count else {
                index = 0
                return
            }
            currentLocation = places[index].coordinate
        }
    }
    
    var mapTypes = ["Normal", "Satellite", "Hybrid"]
    var places: FetchedResults<Place>
    
    init(mapType: Binding<String>,
         places: FetchedResults<Place>,
         currentLocation: Binding<CLLocationCoordinate2D?>?) {
        self._mapType = mapType
        self.places = places
        self._currentLocation = currentLocation ?? Binding.constant(nil)
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .edgesIgnoringSafeArea(.all)
            HStack {
                Image("").frame(width: 48, height: 48)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2, perform: { index -= 1 })
                Picker(selection: $mapType, label: Text("Map Type"), content: {
                    ForEach(mapTypes, id: \.self) { Text($0) }
                })
                .pickerStyle(SegmentedPickerStyle())
                Image("").frame(width: 48, height: 48)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2, perform: { index += 1 })
            }.padding(.all, 8)
        }
        .ignoresSafeArea(.all)
    }
}

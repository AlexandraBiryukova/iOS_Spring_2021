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
    @Binding var index: Int?
    
    private let count: Int
    private var mapTypes = ["Normal", "Satellite", "Hybrid"]
    
    init(mapType: Binding<String>,
         count: Int,
         index: Binding<Int?>?) {
        self._mapType = mapType
        self.count = count
        self._index = index ?? Binding.constant(nil)
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .edgesIgnoringSafeArea(.all)
            HStack {
                Image("").frame(width: 48, height: 48)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2, perform: {
                        if count > 0 && index == nil {
                            index = 0
                        }
                        guard let index = index else { return }
                        guard index >= 1 else {
                            self.index = count - 1
                            return
                        }
                        self.index = index - 1
                        
                    })
                Picker(selection: $mapType, label: Text("Map Type"), content: {
                    ForEach(mapTypes, id: \.self) { Text($0) }
                })
                .pickerStyle(SegmentedPickerStyle())
                Image("").frame(width: 48, height: 48)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2, perform: {
                        if count > 0 && index == nil {
                            index = 0
                        }
                        guard let index = index else { return }
                        guard index + 1 < count else {
                            self.index = 0
                            return
                        }
                        self.index = index + 1
                        
                    })
            }.padding(.all, 8)
        }
        .ignoresSafeArea(.all)
    }
}

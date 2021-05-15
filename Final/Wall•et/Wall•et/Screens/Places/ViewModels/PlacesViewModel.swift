//
//  PlacesViewModel.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

final class PlacesViewModel: ObservableObject {
    @Published var places: [TransactionPlace] = [.init(name: "Test", address: "Test", description: "Test", transactions: 5, category: .clothes, openTime: Date(), closeTime: Date(), isFavourite: true)]
    @Published var filterModel: FilterModel = .init()
    
    func getPlaces() {
        print(filterModel)
        self.places = []
    }

    func indexOf(place: TransactionPlace) -> Int? {
        places.firstIndex(where: { $0.id == place.id })
    }
    
    func changePlace(place: TransactionPlace) {
        guard let index = indexOf(place: place) else {
            addPlace(place: place)
            return
        }
        places[index] = place
    }
    
    func removePlace(place: TransactionPlace) {
        guard let index = indexOf(place: place) else { return }
        places.remove(at: index)
    }
    
    func addPlace(place: TransactionPlace) {
        places.append(place)
    }
}

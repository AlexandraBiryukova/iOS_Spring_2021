//
//  PlacesViewModel.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

final class PlacesViewModel: ObservableObject {
    @Published var places: [TransactionPlace] = [.init(name: "Dostyk", address: "dostyk", description: "test", transactions: 4, categories: [], openTime: Date(), closeTime: Date(), isFavourite: false),
                                                 .init(name: "Dostyk", address: "dostyk", description: "test", transactions: 4, categories: [], openTime: Date(), closeTime: Date(), isFavourite: false),
                                                 .init(name: "Dostyk", address: "dostyk", description: "test", transactions: 4, categories: [], openTime: Date(), closeTime: Date(), isFavourite: false)]

    func changePlace(place: TransactionPlace) {
        guard let index = places.firstIndex(where: { $0.id == place.id }) else { return }
        places[index] = place
    }
    
    func removePlace(place: TransactionPlace) {
        guard let index = places.firstIndex(where: { $0.id == place.id }) else { return }
        places.remove(at: index)
    }
    
    func addPlace(place: TransactionPlace) {
        places.append(place)
    }
}

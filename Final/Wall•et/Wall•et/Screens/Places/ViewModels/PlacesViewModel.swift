//
//  PlacesViewModel.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import KeychainAccess
import SwiftUI

final class PlacesViewModel: ObservableObject {
    private var mainPlaces: [TransactionPlace] = []
    @Published var places: [TransactionPlace] = []
    @Published var filterModel: FilterModel = .init()
    private let storage = AppStorage(keychain: Keychain(), userDefaults: UserDefaults.standard)
    
    init() {
        mainPlaces = storage.places
        mainPlaces.enumerated().forEach { element in
            mainPlaces[element.offset].transactions = storage.transactions.filter { $0.placeId == element.element.id }
        }
        storage.places = mainPlaces
    }
    
    func getPlaces() {
        mainPlaces = storage.places
        mainPlaces.enumerated().forEach { element in
            mainPlaces[element.offset].transactions = storage.transactions.filter { $0.placeId == element.element.id }
        }
        storage.places = mainPlaces
        places = mainPlaces.filter {
            (filterModel.category == .none ? true : $0.category == filterModel.category) &&
                ($0.transactions.count >= filterModel.count.range.min) &&
                ($0.transactions.count <= filterModel.count.range.max) &&
                (filterModel.onlyFavourites ? $0.isFavourite : true) &&
                (filterModel.usingPeriod ? ($0.transactions.contains(where: {
                    $0.createDate >= filterModel.startDate && $0.createDate <= filterModel.endDate
                })) : true)
        }
    }

    func indexOf(place: TransactionPlace) -> Int? {
        mainPlaces.firstIndex(where: { $0.id == place.id })
    }
    
    func changePlace(place: TransactionPlace) {
        guard let index = indexOf(place: place) else {
            addPlace(place: place)
            return
        }
        mainPlaces[index] = place
        storage.places = mainPlaces
        getPlaces()
    }
    
    func addPlace(place: TransactionPlace) {
        mainPlaces.append(place)
        storage.places = mainPlaces
        getPlaces()
    }
    
    func removePlace(place: TransactionPlace) {
        guard let index = indexOf(place: place) else { return }
        mainPlaces.remove(at: index)
        storage.places = mainPlaces
        getPlaces()
    }
}

//
//  TransactionPlace.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import Foundation

struct TransactionPlace: Identifiable, Codable {
    var id = UUID()
    var name: String
    var address: String
    var description: String
    var transactions: [Transaction] = []
    var category: FilterCategory
    var openTime: Date = Date()
    var closeTime: Date = Date()
    var isFavourite = false
    
    init(name: String = "",
         address: String = "",
         description: String = "",
         transactions: [Transaction] = [],
         category: FilterCategory = .none,
         openTime: Date = .init(),
         closeTime: Date = .init(),
         isFavourite: Bool = false) {
        self.name = name
        self.address = address
        self.description = description
        self.transactions = transactions
        self.category = category
        self.openTime = openTime
        self.closeTime = closeTime
        self.isFavourite = isFavourite
    }
}

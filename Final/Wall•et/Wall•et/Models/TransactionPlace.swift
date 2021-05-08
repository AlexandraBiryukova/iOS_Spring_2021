//
//  TransactionPlace.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import Foundation

struct TransactionPlace: Identifiable, Codable {
    var id = UUID()
    var name: String?
    var address: String?
    var description: String?
    var transactions: Int = 0
    var categories: [String] = []
    var openTime: Date?
    var closeTime: Date?
    var isFavourite = false
    
    init(name: String? = nil,
         address: String? = nil,
         description: String? = nil,
         transactions: Int = 0,
         categories: [String] = [],
         openTime: Date? = nil,
         closeTime: Date? = nil,
         isFavourite: Bool = false) {
        self.name = name
        self.address = address
        self.description = description
        self.transactions = transactions
        self.categories = categories
        self.openTime = openTime
        self.closeTime = closeTime
        self.isFavourite = isFavourite
    }
}

//
//  Transaction.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import UIKit

enum TransactionType: String, Codable, CaseIterable {
    case cash, card
    
    var title: String {
        switch self {
        case .cash:
            return "Оплата наличными"
        case .card:
            return "Оплата картой"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .cash:
            return Assets.cash.image
        case .card:
            return Assets.creditCard.image
        }
    }
}

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var data: Data?
    var name: String
    var description: String
    var amount: Double
    var type: TransactionType
    var createDate: Date
    var place: TransactionPlace?
    
    init(name: String = "",
         data: Data? = nil,
         description: String = "",
         amount: Double = 0,
         type: TransactionType = .cash,
         createDate: Date = Date(),
         place: TransactionPlace? = nil) {
        self.name = name
        self.data = data
        self.description = description
        self.amount = amount
        self.type = type
        self.createDate = createDate
        self.place = place
    }
}

//
//  FilterModel.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/10/21.
//

import Foundation

enum TransactionsCount: String, Codable, PickerItem, CaseIterable {
    case none
    case zero = "0"
    case between0and10 = "1 - 10"
    case between10and25 = "11 - 25"
    case moreThan25 = "25>"
    
    var title: String {
        switch self {
        case .none:
            return "Любое"
        default:
            return self.rawValue
        }
    }
}

enum FilterCategory: String, Codable, PickerItem, CaseIterable {
    case products
    case clothes
    case none
    
    var title: String {
        switch self {
        case .none:
            return "Все"
        case .products:
            return "Еда и продукты"
        case .clothes:
            return "Одежда и обувь"
        }
    }
}

struct FilterModel {
    var count: TransactionsCount = .none
    var category: FilterCategory = .none
    var onlyFavourites = false
    var usingPeriod = false
    var startDate = Date()
    var endDate = Date()
}

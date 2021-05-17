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
            return L10n.filterCountNone
        default:
            return self.rawValue
        }
    }
    
    var range: (min: Int, max: Int) {
        switch self {
        case .none:
            return (0, Int.max)
        case .zero:
            return (0, 0)
        case .between0and10:
            return (0, 10)
        case .between10and25:
            return (10, 25)
        case .moreThan25:
            return (25, Int.max)
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
            return L10n.filterCategoryAll
        case .products:
            return L10n.filterCategoryProducts
        case .clothes:
            return L10n.filterCategoryClothes
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

//
//  HomeTransactionCellModel.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import UIKit

struct TransactionCellModel {
    var smallIcon: UIImage {
        transaction.type.icon
    }
    
    var bigIcon: UIImage? {
        guard let data = transaction.data else { return nil }
        return UIImage(data: data)
    }
    
    var title: String {
        transaction.name
    }
    
    var description: String? {
        transaction.description
    }
    
    var amount: String? {
        let value = formatter.string(from: .init(value: transaction.amount),
                                     configurator: .init(maximumFractionDigits: 2)) ?? String(transaction.amount)
        return "\(value) ₸"
    }
    
    var date: String {
        formatter.string(from: transaction.createDate, configurator: .init(dateFormat: "HH:mm"))
    }
    
    private let transaction: Transaction
    private let formatter: PropertyFormatter
    
    init(transaction: Transaction, formatter: PropertyFormatter) {
        self.transaction = transaction
        self.formatter = formatter
    }
}

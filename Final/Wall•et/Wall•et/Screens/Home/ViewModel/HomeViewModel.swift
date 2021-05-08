//
//  HomeViewModel.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    var banners: [Banner] = [
        .init(image: Assets.familyBudget.name, url: "https://www.discover.com/online-banking/banking-topics/7-ways-to-save-money-on-family-expenses/"),
        .init(image: Assets.childEducation.name, url: "https://www.personalfn.com/guide/steps-to-plan-childs-education"),
        .init(image: Assets.startups.name, url: "https://www.forbes.com/advisor/investing/invest-in-startups/")
    ]
//
    @Published var transactions: [Transaction] = [.init(name: "Test", description: "Test", amount: 1000, type: .card, createDate: Date(), place: nil)]

    func changeTransaction(transaction: Transaction) {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        transactions[index] = transaction
    }
    
    func removeTransaction(transaction: Transaction) {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        transactions.remove(at: index)
    }
    
    func addTransaction(transaction: Transaction) {
        transactions.append(transaction)
    }
    
    var transactionsHeight: CGFloat {
        guard !transactions.isEmpty else { return 0 }
        let tableWidth = UIScreen.main.bounds.width - 32
        let numberOfItemsPerLine = Int(tableWidth / max(tableWidth / 4, 80))
        let trancationsCount = max(transactions.count, numberOfItemsPerLine)
        let linesCount = trancationsCount / numberOfItemsPerLine +
            (trancationsCount.isMultiple(of: numberOfItemsPerLine) ? 0 : 1)
        let linesHeight = linesCount * 104
        let linesOffset = max(0, linesCount - 1) * 16
        return CGFloat(linesHeight + linesOffset)
    }
}

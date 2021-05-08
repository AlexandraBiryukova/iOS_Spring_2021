//
//  HomeTransactionsView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI
import UIKit

struct HomeTransactionsView: UIViewRepresentable {
    @Binding var transactions: [Transaction]
    var didSelectTransaction: ((_ object: Transaction) -> ()) = { _ in }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.register(cellClass: HomeTransactionCell.self)
        return collectionView
    }
    
    func updateUIView(_ collectionView: UICollectionView, context: UIViewRepresentableContext<HomeTransactionsView>) {
        collectionView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        private var parent: HomeTransactionsView
        private let formatter = PropertyFormatter(appLanguage: AppLanguage.current)
        init(_ view: HomeTransactionsView) {
            self.parent = view
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.transactions.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell: HomeTransactionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: .init(transaction: parent.transactions[indexPath.item], formatter: formatter))
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            parent.didSelectTransaction(parent.transactions[indexPath.item])
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            .init(width: max(collectionView.frame.width / 4, 80), height: 104)
        }
    }
}

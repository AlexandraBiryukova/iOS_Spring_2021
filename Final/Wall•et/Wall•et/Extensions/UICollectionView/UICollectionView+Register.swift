//
//  UICollectionView+Register.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 2/28/21.
//

import UIKit

extension UICollectionView {
    func register(cellClass: AnyClass) {
        let nib = UINib(nibName: "\(cellClass)", bundle: Bundle(for: cellClass))
        register(nib, forCellWithReuseIdentifier: "\(cellClass)")
    }

    func register(viewClass: AnyClass, forSupplementaryViewOfKind kind: String) {
        let nib = UINib(nibName: "\(viewClass)", bundle: Bundle(for: viewClass))
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: "\(viewClass)")
    }
}

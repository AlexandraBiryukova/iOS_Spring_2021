//
//  Array+Safe.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 2/28/21.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

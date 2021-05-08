//
//  Array+Factory.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 2/28/21.
//

import Foundation

extension Array {
    init(count: Int, factory: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in factory() }
    }

    init(count: Int, factory: () -> Element) {
        self = (0 ..< count).map { _ in factory() }
    }
}

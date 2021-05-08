//
//  String+Replacing.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 2/28/21.
//

import Foundation

extension String {
    func replacingOccurrences(of strings: [String], with replacement: String) -> String {
        var newString = self
        strings.forEach { newString = newString.replacingOccurrences(of: $0, with: replacement) }
        return newString
    }
}

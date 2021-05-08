//
//  ValidationRule.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 4/15/21.
//

import Foundation

enum ValidationPattern: String {
    case phoneNumber = "^[0-9]{11}$"
    case letter = "^.*?[a-zA-Z].*?$"
    case number = ".*[0-9].*"
}

struct ValidationRule {
    let title: String
    let pattern: String?
    let patternType: ValidationPattern?
    let condition: Bool?
    
    init(title: String,
         pattern: String? = nil,
         type: ValidationPattern? = nil,
         condition: Bool? = nil) {
        self.title = title
        self.pattern = pattern
        self.patternType = type
        self.condition = condition
    }
    
    func check(_ value: String) -> Bool {
        guard let condition = condition else {
            let finalPattern = patternType?.rawValue ?? (pattern ?? "")
            guard !finalPattern.isEmpty else { return true }
            let predicate = NSPredicate(format: "SELF MATCHES %@", finalPattern)
            return predicate.evaluate(with: value)
        }
        return condition
    }
}

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

struct EmailValidationPattern {
    let pattern = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

    init() {}
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

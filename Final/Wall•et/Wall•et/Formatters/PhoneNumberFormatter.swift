//
//  PhoneNumberFormatter.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 4/13/20.
//

import Foundation

protocol PhoneNumberFormatter {
    func formattedPhoneNumber(from text: String) -> String?
    func formattedHiddenPhoneNumber(from text: String) -> String?
    func rawPhoneNumber(from text: String) -> String?
    func validatePhoneNumber(input: String?) -> Bool
}

private enum Constants {
    static let digitsCount = 11
}

extension PropertyFormatter: PhoneNumberFormatter {
    func formattedPhoneNumber(from text: String) -> String? {
        let digits = text.unicodeScalars
            .filter { CharacterSet.decimalDigits.contains($0) }
            .map { String($0) }
        guard digits.count <= Constants.digitsCount, !digits.isEmpty else { return nil }

        var formattedString = "+"
        for (index, digit) in digits.enumerated() {
            switch index {
            case 1:
                formattedString += " (\(digit)"
            case 3:
                formattedString += "\(digit)) "
            case 7:
                formattedString += "-\(digit)"
            default:
                formattedString += digit
            }
        }
        return formattedString
    }

    func formattedHiddenPhoneNumber(from text: String) -> String? {
        guard let phoneNumber = formattedPhoneNumber(from: text) else { return nil }
        var text = phoneNumber
        text = text.replacingOccurrences(of: " ", with: "")
        text = text.prefix(2) + "•••" + text.suffix(4)
        return text
    }

    func rawPhoneNumber(from text: String) -> String? {
        let digits = text.unicodeScalars
            .filter { CharacterSet.decimalDigits.contains($0) }
            .map { String($0) }
            .joined()
        guard digits.count <= Constants.digitsCount else { return nil }
        return digits
    }
    
    func validatePhoneNumber(input: String?) -> Bool {
        guard let phoneNumber = rawPhoneNumber(from: input ?? "") else { return false }
        let predicate = NSPredicate(format: "SELF MATCHES %@", ValidationPattern.phoneNumber.rawValue)
        return predicate.evaluate(with: phoneNumber)
    }
}

//
//  AppLanguageStorage.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import Foundation

private enum Constants {
    static let appLanguage = "appLanguage"
}

extension AppLanguage {
    static var preferredLanguages: [String] {
        [current.rawValue]
    }
    
    static var current: AppLanguage {
        getCurrentLanguage()
    }
    
    private static func getCurrentLanguage() -> AppLanguage {
        if let rawValue = Bundle.main.preferredLocalizations.first ?? Locale.current.languageCode,
           let appLanguage = AppLanguage(rawValue: rawValue) {
            return appLanguage
        } else {
            return .default
        }
    }
}

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
        get { getCurrentLanguage() }
        set { _current = newValue.rawValue }
    }

    private static var _current: String? {
        get { UserDefaults.standard.string(forKey: Constants.appLanguage) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.appLanguage) }
    }

    private static func getCurrentLanguage() -> AppLanguage {
        if let rawValue = _current,
            let appLanguage = AppLanguage(rawValue: rawValue) {
            return appLanguage
        } else {
            if let rawValue = Bundle.main.preferredLocalizations.first ?? Locale.current.languageCode,
                let appLanguage = AppLanguage(rawValue: rawValue) {
                return appLanguage
            } else {
                return .default
            }
        }
    }
}

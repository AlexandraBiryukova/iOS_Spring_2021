//
//  AppLanguage.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import Foundation

enum AppLanguage: String, PickerItem, CaseIterable, Codable {
    case kk
    case ru
    case en
}

extension AppLanguage {
    static let `default` = AppLanguage.ru

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    var title: String {
        switch self {
        case .ru:
            return L10n.appLanguageRuNative
        case .en:
            return L10n.appLanguageEnNative
        case .kk:
            return L10n.appLanguageKkNative
        }
    }

    func titleInCurrentLanguage(language: AppLanguage) -> String {
        switch self {
        case .ru:
            switch language {
            case .kk:
                return L10n.appLanguageRuInKazakhLanguage
            case .ru:
                return L10n.appLanguageRuNative
            case .en:
                return L10n.appLanguageRuInEnglishLanguage
            }
        case .en:
            switch language {
            case .kk:
                return L10n.appLanguageEnInKazakhLanguage
            case .ru:
                return L10n.appLanguageEnInRussianLanguage
            case .en:
                return L10n.appLanguageEnNative
            }
        case .kk:
            switch language {
            case .kk:
                return L10n.appLanguageKkNative
            case .ru:
                return L10n.appLanguageKkInRussianLanguage
            case .en:
                return L10n.appLanguageKkInEnglishLanguage
            }
        }
    }
}

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Русский
  internal static var appLanguageCurrent: String { return L10n.tr("Localizable", "AppLanguage.current") }
  /// Ағылшын
  internal static var appLanguageEnInKazakhLanguage: String { return L10n.tr("Localizable", "AppLanguage.en.inKazakhLanguage") }
  /// Английский
  internal static var appLanguageEnInRussianLanguage: String { return L10n.tr("Localizable", "AppLanguage.en.inRussianLanguage") }
  /// English
  internal static var appLanguageEnNative: String { return L10n.tr("Localizable", "AppLanguage.en.native") }
  /// Kazakh
  internal static var appLanguageKkInEnglishLanguage: String { return L10n.tr("Localizable", "AppLanguage.kk.inEnglishLanguage") }
  /// Казахский
  internal static var appLanguageKkInRussianLanguage: String { return L10n.tr("Localizable", "AppLanguage.kk.inRussianLanguage") }
  /// Қазақ
  internal static var appLanguageKkNative: String { return L10n.tr("Localizable", "AppLanguage.kk.native") }
  /// Russian
  internal static var appLanguageRuInEnglishLanguage: String { return L10n.tr("Localizable", "AppLanguage.ru.inEnglishLanguage") }
  /// Орыс
  internal static var appLanguageRuInKazakhLanguage: String { return L10n.tr("Localizable", "AppLanguage.ru.inKazakhLanguage") }
  /// Русский
  internal static var appLanguageRuNative: String { return L10n.tr("Localizable", "AppLanguage.ru.native") }
  /// Главная
  internal static var tabHome: String { return L10n.tr("Localizable", "Tab.home") }
  /// Места транзакций
  internal static var tabPlaces: String { return L10n.tr("Localizable", "Tab.places") }
  /// Профиль
  internal static var tabProfile: String { return L10n.tr("Localizable", "Tab.profile") }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    var bundle = Bundle(for: BundleToken.self)
    if let path = Bundle.main.path(forResource: AppLanguage.current.rawValue, ofType: "lproj"),
       let pathBundle = Bundle(path: path) {
        bundle = pathBundle
    }
    let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    return String(format: format, locale: AppLanguage.current.locale, arguments: args)
  }
}

private final class BundleToken {}

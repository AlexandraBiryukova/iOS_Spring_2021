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
  /// Отмена
  internal static var coreCancel: String { return L10n.tr("Localizable", "Core.cancel") }
  /// Удалить
  internal static var coreDelete: String { return L10n.tr("Localizable", "Core.delete") }
  /// Готово
  internal static var coreDone: String { return L10n.tr("Localizable", "Core.done") }
  /// Фильтр
  internal static var coreFilter: String { return L10n.tr("Localizable", "Core.filter") }
  /// Перейти
  internal static var coreGo: String { return L10n.tr("Localizable", "Core.go") }
  /// Далее
  internal static var coreNext: String { return L10n.tr("Localizable", "Core.next") }
  /// Нет
  internal static var coreNo: String { return L10n.tr("Localizable", "Core.no") }
  /// Здесь ничего нет
  internal static var coreNotFound: String { return L10n.tr("Localizable", "Core.notFound") }
  /// Сохранить
  internal static var coreSave: String { return L10n.tr("Localizable", "Core.save") }
  /// Да
  internal static var coreYes: String { return L10n.tr("Localizable", "Core.yes") }
  /// Сделать фото
  internal static var imagePickerServiceCamera: String { return L10n.tr("Localizable", "ImagePickerService.camera") }
  /// Чтобы продолжить, перейдите в системные настройки и разрешите доступ к камере
  internal static var imagePickerServiceCameraPermissionDeniedTitle: String { return L10n.tr("Localizable", "ImagePickerService.cameraPermissionDeniedTitle") }
  /// Выбрать из галереи
  internal static var imagePickerServicePhotoLibrary: String { return L10n.tr("Localizable", "ImagePickerService.photoLibrary") }
  /// Чтобы продолжить, перейдите в системные настройки и разрешите доступ к галерее
  internal static var imagePickerServicePhotoLibraryPermissionDeniedTitle: String { return L10n.tr("Localizable", "ImagePickerService.photoLibraryPermissionDeniedTitle") }
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

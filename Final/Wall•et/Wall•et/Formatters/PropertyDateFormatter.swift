//
//  PropertyDateFormatter.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 4/13/20.
//

import Foundation

struct PropertyDateFormatterConfigurator {
    let dateFormat: String
    let timeZone: TimeZone

    init(dateFormat: String, timeZone: TimeZone = .current) {
        self.dateFormat = dateFormat
        self.timeZone = timeZone
    }
}

protocol PropertyDateFormatter {
    func string(from date: Date, configurator: PropertyDateFormatterConfigurator) -> String
    func date(from string: String, configurator: PropertyDateFormatterConfigurator) -> Date?
}

extension PropertyFormatter: PropertyDateFormatter {
    @Atomic private static var formatter = DateFormatter()

    func string(from date: Date, configurator: PropertyDateFormatterConfigurator) -> String {
        configureFormatter(with: configurator)
        return PropertyFormatter.formatter.string(from: date)
    }

    func date(from string: String, configurator: PropertyDateFormatterConfigurator) -> Date? {
        configureFormatter(with: configurator)
        return PropertyFormatter.formatter.date(from: string)
    }

    private func configureFormatter(with configurator: PropertyDateFormatterConfigurator) {
        PropertyFormatter.$formatter.mutate {
            $0.dateFormat = configurator.dateFormat
            $0.locale = appLanguage.locale
            $0.timeZone = configurator.timeZone
        }
    }
}

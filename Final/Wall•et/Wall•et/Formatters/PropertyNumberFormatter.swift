//
//  PropertyNumberFormatter.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 4/13/20.
//

import Foundation

struct PropertyNumberFormatterConfigurator {
    let decimalSeparator: String
    let groupingSeparator: String
    let maximum: NSNumber?
    let minimumFractionDigits: Int
    let maximumFractionDigits: Int
    let numberStyle: NumberFormatter.Style
    let roundingMode: NumberFormatter.RoundingMode

    init(decimalSeparator: String = ".",
         groupingSeparator: String = " ",
         maximum: NSNumber? = nil,
         minimumFractionDigits: Int = 0,
         maximumFractionDigits: Int = 0,
         numberStyle: NumberFormatter.Style = .decimal,
         roundingMode: NumberFormatter.RoundingMode = .halfEven) {
        self.decimalSeparator = decimalSeparator
        self.groupingSeparator = groupingSeparator
        self.maximum = maximum
        self.minimumFractionDigits = minimumFractionDigits
        self.maximumFractionDigits = maximumFractionDigits
        self.numberStyle = numberStyle
        self.roundingMode = roundingMode
    }
}

protocol PropertyNumberFormatter {
    func string(from number: NSNumber, configurator: PropertyNumberFormatterConfigurator) -> String?
    func number(from string: String, configurator: PropertyNumberFormatterConfigurator) -> NSNumber?
}

extension PropertyFormatter: PropertyNumberFormatter {
    @Atomic private static var formatter = NumberFormatter()

    func string(from number: NSNumber, configurator: PropertyNumberFormatterConfigurator) -> String? {
        configureFormatter(with: configurator)
        return PropertyFormatter.formatter.string(from: number)
    }

    func number(from string: String, configurator: PropertyNumberFormatterConfigurator) -> NSNumber? {
        configureFormatter(with: configurator)
        return PropertyFormatter.formatter.number(from: string)
    }

    private func configureFormatter(with configurator: PropertyNumberFormatterConfigurator) {
        PropertyFormatter.$formatter.mutate {
            $0.decimalSeparator = configurator.decimalSeparator
            $0.groupingSeparator = configurator.groupingSeparator
            $0.locale = appLanguage.locale
            $0.maximum = configurator.maximum
            $0.minimumFractionDigits = configurator.minimumFractionDigits
            $0.maximumFractionDigits = configurator.maximumFractionDigits
            $0.numberStyle = configurator.numberStyle
            $0.roundingMode = configurator.roundingMode
        }
    }
}

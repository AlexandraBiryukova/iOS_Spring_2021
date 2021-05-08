//
//  Date+Convenience.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 7/13/20.
//

import Foundation

extension Date {
    static var now: Date { Date() }

    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }

    var startOfMonth: Date {
        let calendar = Calendar.current
        let currentDateComponents = (calendar as NSCalendar).components([.year, .month], from: self)
        let startOfMonth = calendar.date(from: currentDateComponents)!
        return startOfMonth
    }

    var endOfMonth: Date {
        let plusOneMonthDate = dateByAddingMonths(1)!
        let calendar = Calendar.current
        let plusOneMonthDateComponents = (calendar as NSCalendar).components([.year, .month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        return endOfMonth!
    }

    var startOfDay: Date {
        let calendar = Calendar.current
        let date = (calendar as NSCalendar).startOfDay(for: self)
        return date
    }

    var monthToInt: Int {
        (Calendar.current as NSCalendar).component(.month, from: self)
    }

    var nextMonth: Date {
        let calendar = Calendar.current
        let date = (calendar as NSCalendar).date(byAdding: .month, value: 1, to: self, options: [])!
        return date
    }

    var weekday: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return (calendar as NSCalendar).ordinality(of: .weekday, in: .weekOfMonth, for: self) - 1
    }

    var dayToInt: Int {
        (Calendar.current as NSCalendar).component(.day, from: self)
    }

    func month(with locale: Locale) -> String {
        var calendar = Calendar.current
        calendar.locale = locale
        let comp: DateComponents = (calendar as NSCalendar).components(.month, from: self)
        return calendar.standaloneMonthSymbols[comp.month! - 1].capitalized
    }

    func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd
        return (calendar as NSCalendar).date(byAdding: months, to: self, options: [])
    }

    func dateByAddingDays(_ daysToAdd: Int) -> Date? {
        let calendar = Calendar.current
        var days = DateComponents()
        days.day = daysToAdd
        return (calendar as NSCalendar).date(byAdding: days, to: self, options: [])
    }

    func monthsFrom(_ date: Date) -> Int {
        (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month! + 1
    }

    func daysBetween(_ date: Date) -> Int {
        abs((Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!)
    }
}

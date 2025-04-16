//
//  TimeInterval.swift
//  Stock Tracker
//
//  Created by Sylvan  on 17/04/2025.
//

import Foundation

private enum DateFormatters {
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    static let dateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d h:mm:ss a"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
}

extension TimeInterval {
    func asDateString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        return DateFormatters.fullDate.string(from: date)
    }

    func asDateTimeString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        return DateFormatters.dateTime.string(from: date)
    }

    func asTimeString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        return DateFormatters.timeOnly.string(from: date)
    }
}

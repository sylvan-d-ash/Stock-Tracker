//
//  TimeInterval.swift
//  Stock Tracker
//
//  Created by Sylvan  on 17/04/2025.
//

import Foundation

extension TimeInterval {
    func asDateString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }

    func asDateTimeString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MMM d h:mm:ss a"
        return dateFormatter.string(from: date)
    }

    func asTimeString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a"
        return dateFormatter.string(from: date)
    }
}

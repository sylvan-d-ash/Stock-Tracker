//
//  Int.swift
//  Stock Tracker
//
//  Created by Sylvan  on 17/04/2025.
//

import Foundation

extension Int {
    func formattedMarketCap() -> String {
        let number = Double(self)

        switch number {
        case 1_000_000_000_000...:
            return String(format: "%.2fT", number / 1_000_000_000_000)
        case 1_000_000_000...:
            return String(format: "%.2fB", number / 1_000_000_000)
        case 1_000_000...:
            return String(format: "%.2fM", number / 1_000_000)
        default:
            return String(format: "%.0f", number) // No suffix for numbers below 1M
        }
    }
}

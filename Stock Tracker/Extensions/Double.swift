//
//  Double.swift
//  Stock Tracker
//
//  Created by Sylvan  on 17/04/2025.
//

import Foundation

extension Double {
    func roundedToTwoDecimalString() -> String {
        let value = ceil(self * 100) / 100
        return String(format: "%.2f", value)
    }

    func asPercentageString() -> String {
        return "\(self > 0 ? "+" : "")" + self.roundedToTwoDecimalString() + "%"
    }
}

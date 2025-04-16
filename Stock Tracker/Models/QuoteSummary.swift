//
//  QuoteSummary.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation

struct QuoteResponse: Decodable {
    let result: [QuoteSummary]
    let error: String?
}

struct QuoteSummary: Decodable {
    let symbol: String
    let shortName: String
    let quoteType: String

    let regularMarketPrice: Double
    let regularMarketChange: Double
    let regularMarketChangePercent: Double
    let regularMarketTime: TimeInterval

    let preMarketPrice: Double
    let preMarketChange: Double
    let preMarketChangePercent: Double
    let preMarketTime: TimeInterval

    let postMarketPrice: Double
    let postMarketChange: Double
    let postMarketChangePercent: Double
    let postMarketTime: TimeInterval

    let regularMarketDayHigh: Double
    let regularMarketDayLow: Double
    let regularMarketOpen: Double
    let regularMarketPreviousClose: Double
    let regularMarketVolume: Int
    let averageDailyVolume3Month: Int

    let exchangeTimezoneShortName: String
    let gmtOffSetMilliseconds: Int

    let bid: Double
    let ask: Double
    let bidSize: Int
    let askSize: Int
    let beta: Double
    let fiftyTwoWeekLow: Double
    let fiftyTwoWeekHigh: Double

    let marketCap: Int
    let trailingPE: Double
    let epsTrailingTwelveMonths: Double
    let earningsTimestamp: TimeInterval
    let dividendRate: Double?
    let dividendYield: Double?
    let exDividendDate: TimeInterval
    let targetPriceMean: Double
}

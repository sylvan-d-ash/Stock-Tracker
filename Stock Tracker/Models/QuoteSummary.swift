//
//  QuoteSummary.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation

struct QuoteResponse: Decodable {
    let quoteResponse: QuoteResult
}

struct QuoteResult: Decodable {
    let result: [QuoteSummary]
    let error: String?
}

struct QuoteSummary: Decodable {
    let symbol: String
    let shortName: String
    let quoteType: String

    let regularMarketPrice: Double?
    let regularMarketChange: Double?
    let regularMarketChangePercent: Double?
    let regularMarketTime: TimeInterval?

    let preMarketPrice: Double?
    let preMarketChange: Double?
    let preMarketChangePercent: Double?
    let preMarketTime: TimeInterval?

    let postMarketPrice: Double?
    let postMarketChange: Double?
    let postMarketChangePercent: Double?
    let postMarketTime: TimeInterval?

    let regularMarketDayHigh: Double?
    let regularMarketDayLow: Double?
    let regularMarketOpen: Double?
    let regularMarketPreviousClose: Double?
    let regularMarketVolume: Int?
    let averageDailyVolume3Month: Int?

    let exchangeTimezoneShortName: String
    let gmtOffSetMilliseconds: Int

    let bid: Double?
    let ask: Double?
    let bidSize: Int?
    let askSize: Int?
    let beta: Double?
    let fiftyTwoWeekLow: Double?
    let fiftyTwoWeekHigh: Double?

    let marketCap: Int?
    let trailingPE: Double?
    let epsTrailingTwelveMonths: Double?
    let earningsTimestamp: TimeInterval?
    let dividendRate: Double?
    let dividendYield: Double?
    let exDividendDate: TimeInterval?
    let targetPriceMean: Double?

    var bidLot: Int { return bidSize ?? 0 * 100 }
    var askLot: Int { return askSize ?? 0 * 100 }
}

extension QuoteSummary {
    static let mockData: QuoteSummary = QuoteSummary(
        symbol: "AAPL",
        shortName: "Apple Inc.",
        quoteType: "EQUITY",

        // Regular Market
        regularMarketPrice: 202.14,
        regularMarketChange: -0.38,
        regularMarketChangePercent: -0.1876382,
        regularMarketTime: 1744747202,

        // Pre-Market
        preMarketPrice: 200.4,
        preMarketChange: -1.74001,
        preMarketChangePercent: -0.860792,
        preMarketTime: 1744796326,

        // Post-Market
        postMarketPrice: 199.8,
        postMarketChange: -2.34,
        postMarketChangePercent: -1.15761,
        postMarketTime: 1744761597,

        regularMarketDayHigh: 203.505,
        regularMarketDayLow: 199.82,
        regularMarketOpen: 201.855,
        regularMarketPreviousClose: 202.52,
        regularMarketVolume: 50_304_417,
        averageDailyVolume3Month: 62_705_940,

        exchangeTimezoneShortName: "EDT",
        gmtOffSetMilliseconds: -14_400_000,

        bid: 202.14,
        ask: 202.28,
        bidSize: 2, // 2 * 100 = 200
        askSize: 1, // 1 * 100 = 100
        beta: 1.259,
        fiftyTwoWeekLow: 164.08,
        fiftyTwoWeekHigh: 260.1,

        marketCap: 3_037_000_000_000,
        trailingPE: 32.034866,
        epsTrailingTwelveMonths: 6.31,
        earningsTimestamp: 1746129600,
        dividendRate: 1.0,
        dividendYield: 0.49,
        exDividendDate: 1739184000,
        targetPriceMean: 237.39
    )
}

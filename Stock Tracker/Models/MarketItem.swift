//
//  MarketItem.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation

struct MarketSummaryResponse: Codable {
    let marketSummaryAndSparkResponse: MarketResult
}

struct MarketResult: Codable {
    let result: [MarketItem]
    let error: String?
}

struct MarketItem: Codable {
    struct PriceInfo: Codable {
        let raw: Double
        let fmt: String
    }
    
    let symbol: String
    let shortName: String
    let marketState: String
    let regularMarketPrice: PriceInfo?
    let regularMarketPreviousClose: PriceInfo?
    let quoteType: String

    var change: Double {
        guard let price = regularMarketPrice?.raw, let previousClose = regularMarketPreviousClose?.raw else {
            return 0
        }
        
        let change = price - previousClose
        return (change / price) * 100
    }
}

extension MarketItem {
    static let mockData: [MarketItem] = [
        MarketItem(
            symbol: "^GSPC",
            shortName: "S&P 500",
            marketState: "REGULAR",
            regularMarketPrice: .init(raw: 4200.00, fmt: "4,200.00"),
            regularMarketPreviousClose: .init(raw: 4180.00, fmt: "4,180.00"),
            quoteType: "FUTURE"
        ),
        MarketItem(
            symbol: "^DJI",
            shortName: "Dow Jones",
            marketState: "REGULAR",
            regularMarketPrice: .init(raw: 35000.00, fmt: "35,000.00"),
            regularMarketPreviousClose: .init(raw: 35100.00, fmt: "35,100.00"),
            quoteType: "INDEX"
        ),
        MarketItem(
            symbol: "^IXIC",
            shortName: "NASDAQ",
            marketState: "CLOSED",
            regularMarketPrice: .init(raw: 14500.00, fmt: "14,500.00"),
            regularMarketPreviousClose: .init(raw: 14400.00, fmt: "14,400.00"),
            quoteType: "INDEX"
        ),
        MarketItem(
            symbol: "AAPL",
            shortName: "Apple Inc.",
            marketState: "REGULAR",
            regularMarketPrice: .init(raw: 175.00, fmt: "175.00"),
            regularMarketPreviousClose: .init(raw: 172.00, fmt: "172.00"),
            quoteType: "EQUITY"
        ),
        MarketItem(
            symbol: "TSLA",
            shortName: "Tesla Inc.",
            marketState: "REGULAR",
            regularMarketPrice: .init(raw: 700.00, fmt: "700.00"),
            regularMarketPreviousClose: .init(raw: 710.00, fmt: "710.00"),
            quoteType: "EQUITY"
        ),
        MarketItem(
            symbol: "MSFT",
            shortName: "Microsoft Corp.",
            marketState: "REGULAR",
            regularMarketPrice: .init(raw: 330.00, fmt: "330.00"),
            regularMarketPreviousClose: .init(raw: 325.00, fmt: "325.00"),
            quoteType: "CRYPTOCURRENCY"
        ),
        MarketItem(
            symbol: "^RUT",
            shortName: "Russell 2000",
            marketState: "PRE",
            regularMarketPrice: .init(raw: 1900.00, fmt: "1,900.00"),
            regularMarketPreviousClose: .init(raw: 1895.00, fmt: "1,895.00"),
            quoteType: "INDEX"
        ),
        MarketItem(
            symbol: "GOOG",
            shortName: "Alphabet Inc.",
            marketState: "CLOSED",
            regularMarketPrice: .init(raw: 2800.00, fmt: "2,800.00"),
            regularMarketPreviousClose: .init(raw: 2810.00, fmt: "2,810.00"),
            quoteType: "CURRENCY"
        ),
        MarketItem(
            symbol: "AMZN",
            shortName: "Amazon.com",
            marketState: "REGULAR",
            regularMarketPrice: .init(raw: 120.00, fmt: "120.00"),
            regularMarketPreviousClose: .init(raw: 118.50, fmt: "118.50"),
            quoteType: "MUTUALFUND"
        ),
        MarketItem(
            symbol: "^VIX",
            shortName: "Volatility Index",
            marketState: "REGULAR",
            regularMarketPrice: .init(raw: 19.25, fmt: "19.25"),
            regularMarketPreviousClose: .init(raw: 19.00, fmt: "19.00"),
            quoteType: "INDEX"
        )
    ]
}

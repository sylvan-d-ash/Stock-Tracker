//
//  MockService.swift
//  Stock TrackerTests
//
//  Created by Sylvan  on 17/04/2025.
//

import Foundation
@testable import Stock_Tracker

final class MockService: MarketItemsService {
    var marketResult: Result<Stock_Tracker.MarketSummaryResponse, Error>?
    var summaryResult: Result<Stock_Tracker.QuoteResponse, Error>?
    var delay: TimeInterval?

    func fetchMarketItems() async -> Result<Stock_Tracker.MarketSummaryResponse, any Error> {
        if let delay = delay {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        return marketResult ?? .failure(APIError.noData)
    }

    func fetchSummary(for symbols: [String]) async -> Result<Stock_Tracker.QuoteResponse, any Error> {
        if let delay = delay {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        return summaryResult ?? .failure(APIError.noData)
    }
}

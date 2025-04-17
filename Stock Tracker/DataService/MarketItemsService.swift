//
//  MarketItemsService.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation

enum MarketItemsEndpoint: APIEndpoint {
    case marketItems
    case summary(symbols: [String])

    var path: String {
        switch self {
        case .marketItems:
            return "/market/v2/get-summary"
        case .summary:
            return "/market/v2/get-quotes"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .marketItems:
            return ["region": "US"]
        case .summary(let symbols):
            return [
                "symbols": symbols.joined(separator: ","),
                "region": "US"
            ]
        }
    }
}

protocol MarketItemsService {
    func fetchMarketItems() async -> Result<MarketSummaryResponse, Error>
    func fetchSummary(for symbols: [String]) async -> Result<QuoteResponse, Error>
}

final class DefaultMarketItemsService: MarketItemsService {
    private let apiClient: APIClient
    private let useMockData: Bool

    init(apiClient: APIClient = URLSessionaAPIClient(), useMockData: Bool = false) {
        self.apiClient = apiClient
        self.useMockData = useMockData
    }
    
    func fetchMarketItems() async -> Result<MarketSummaryResponse, Error> {
        if useMockData {
            let mockData = MarketSummaryResponse(
                marketSummaryAndSparkResponse: MarketResult(
                    result: MarketItem.mockData,
                    error: nil
                )
            )
            return .success(mockData)
        }

        return await apiClient.fetch(MarketItemsEndpoint.marketItems)
    }

    func fetchSummary(for symbols: [String]) async -> Result<QuoteResponse, any Error> {
        if useMockData {
            let mockData = QuoteResponse(result: [QuoteSummary.mockData], error: nil)
            return .success(mockData)
        }

        return await apiClient.fetch(MarketItemsEndpoint.summary(symbols: symbols))
    }
}

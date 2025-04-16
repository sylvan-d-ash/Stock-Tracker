//
//  MarketItemsService.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation

enum MarketItemsEndpoint: APIEndpoint {
    case getMarketItems

    var path: String {
        switch self {
        case .getMarketItems:
            return "/market/v2/get-summary"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getMarketItems:
            return ["region": "US"]
        }
    }
}

protocol MarketItemsService {
    func getMarketItems() async -> Result<MarketSummaryResponse, Error>
}

final class DefaultMarketItemsService: MarketItemsService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = URLSessionaAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getMarketItems() async -> Result<MarketSummaryResponse, Error> {
        return await apiClient.fetch(MarketItemsEndpoint.getMarketItems)
    }
}

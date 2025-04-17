//
//  MarketSummaryViewModel.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation
import Combine

@MainActor
final class MarketSummaryViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    private let service: MarketItemsService
    private var useMockData = true
    private var markets: [MarketItem] = []

    var filteredMarkets: [MarketItem] {
        if searchText.isEmpty {
            return markets
        }
        return markets.filter { $0.shortName.localizedCaseInsensitiveContains(searchText) }
    }

    init(service: MarketItemsService = DefaultMarketItemsService()) {
        self.service = service
    }

    func fetchMarketData() async {
        if useMockData {
            markets = MarketItem.mockData
            return
        }

        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        let result = await service.fetchMarketItems()
        switch result {
        case .success(let response):
            if let error = response.marketSummaryAndSparkResponse.error {
                errorMessage = error
                return
            }

            markets = response.marketSummaryAndSparkResponse.result
        case .failure(let error):
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}


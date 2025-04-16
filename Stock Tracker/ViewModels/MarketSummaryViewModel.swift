//
//  MarketSummaryViewModel.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation
import Combine

@MainActor
class MarketSummaryViewModel: ObservableObject {
    @Published var markets: [MarketItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: MarketItemsService
    private var useMockData = true

    init(service: MarketItemsService = DefaultMarketItemsService()) {
        self.service = service
    }

    func fetchMarketData() async {
        if useMockData {
            self.markets = MarketItem.mockData
            return
        }

        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        let result = await service.getMarketItems()
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


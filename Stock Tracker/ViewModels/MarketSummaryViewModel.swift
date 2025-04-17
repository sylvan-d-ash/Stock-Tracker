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
    @Published private var markets: [MarketItem] = []

    private let service: MarketItemsService
    private let pollInterval: TimeInterval
    private var timer: Timer?

    var filteredMarkets: [MarketItem] {
        if searchText.isEmpty {
            return markets
        }
        return markets.filter { $0.shortName.localizedCaseInsensitiveContains(searchText) }
    }

    init(service: MarketItemsService = DefaultMarketItemsService(), pollInterval: TimeInterval = 8) {
        self.service = service
        self.pollInterval = pollInterval
    }

    deinit {
        timer?.invalidate()
    }

    func fetchMarketData() async {
        guard !isLoading else { return }

        if markets.isEmpty || errorMessage != nil {
            isLoading = true
        }

        errorMessage = nil

        let result = await service.fetchMarketItems()
        switch result {
        case .success(let response):
            if let error = response.marketSummaryAndSparkResponse.error {
                errorMessage = error
                isLoading = false
                return
            }

            markets = response.marketSummaryAndSparkResponse.result
        case .failure(let error):
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchMarketData()
            }
        }
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }
}

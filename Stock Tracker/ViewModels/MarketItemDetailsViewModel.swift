//
//  MarketItemDetailsViewModel.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation
import Combine

@MainActor
final class MarketItemDetailsViewModel: ObservableObject {
    @Published var summary: QuoteSummary?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let item: MarketItem
    private let service: MarketItemsService
    private var useMockData = true

    init(item: MarketItem, service: MarketItemsService = DefaultMarketItemsService()) {
        self.item = item
        self.service = service
    }

    func fetchSummary() async {
        if useMockData {
            summary = QuoteSummary.mockData
            return
        }

        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        let result = await service.fetchSummary(for: [item.symbol])

        switch result {
        case .success(let response):
            if let error = response.error {
                errorMessage = error
                return
            }
            summary = response.result.first
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}

//
//  MarketSummaryViewModelTests.swift
//  Stock TrackerTests
//
//  Created by Sylvan  on 15/04/2025.
//

import Foundation
import Testing
@testable import Stock_Tracker

struct MarketSummaryViewModelTests {

    struct MockService: MarketItemsService {
        let result: Result<Stock_Tracker.MarketSummaryResponse, Error>
        let delay: TimeInterval

        func fetchMarketItems() async -> Result<Stock_Tracker.MarketSummaryResponse, any Error> {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            return result
        }
        
        func fetchSummary(for symbols: [String]) async -> Result<Stock_Tracker.QuoteResponse, any Error> {
            fatalError("Not needed for now")
        }
    }

    @Test
    func testSuccessResponse() async throws {
        let item = MarketItem.mockData[0]
        let mockResponse = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketResult(
                result: [item],
                error: nil
            )
        )
        let service = MockService(result: .success(mockResponse), delay: 0)
        let viewModel = await MarketSummaryViewModel(service: service)

        await viewModel.fetchMarketData()

        await #expect(viewModel.filteredMarkets.count == 1)
        await #expect(viewModel.filteredMarkets.first?.symbol == item.symbol)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testErrorResponse() async throws {
        let error = "An error occurred."
        let mockResponse = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketResult(
                result: [],
                error: error
            )
        )
        let service = MockService(result: .success(mockResponse), delay: 0)
        let viewModel = await MarketSummaryViewModel(service: service)

        await viewModel.fetchMarketData()

        await #expect(viewModel.filteredMarkets.isEmpty)
        await #expect(viewModel.errorMessage == error)
        await #expect(viewModel.isLoading == false)
    }

    @Test
    func testAPIError() async throws {
        let error = APIError.noData
        let service = MockService(result: .failure(error), delay: 0)
        let viewModel = await MarketSummaryViewModel(service: service)

        await viewModel.fetchMarketData()

        await #expect(viewModel.filteredMarkets.isEmpty)
        await #expect(viewModel.errorMessage == error.localizedDescription)
        await #expect(viewModel.isLoading == false)
    }

    @MainActor @Test
    func testNoDataFetchWhenAlreadyLoading() async throws {
        let item = MarketItem.mockData[0]
        let mockResponse = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketResult(
                result: [item],
                error: nil
            )
        )
        let service = MockService(result: .success(mockResponse), delay: 0)
        let viewModel = MarketSummaryViewModel(service: service)
        viewModel.isLoading = true

        await viewModel.fetchMarketData()

        // Expect no change
        #expect(viewModel.filteredMarkets.isEmpty)
    }

    @Test
    func testIsLoadingIsToggledDuringFetch() async throws {
        // arrange
        let item = MarketItem.mockData[0]
        let mockResponse = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketResult(
                result: [item],
                error: nil
            )
        )
        let service = MockService(result: .success(mockResponse), delay: 0.1) // small delay
        let viewModel = await MarketSummaryViewModel(service: service)

        // assert initial state
        await #expect(viewModel.isLoading == false)

        // act
        let task = Task {
            await viewModel.fetchMarketData()
        }

        // 10ms delay to let the state update
        try? await Task.sleep(nanoseconds: 10_000_000)

        // assert new state
        await #expect(viewModel.isLoading == true)

        // wait for fetch to finish
        await task.value

        // assert final state
        await #expect(viewModel.isLoading == false)
    }

    @MainActor @Test
    func testFilterWithEmptySearchText() async throws {
        let mockResponse = MarketSummaryResponse(
            marketSummaryAndSparkResponse: MarketResult(
                result: MarketItem.mockData,
                error: nil
            )
        )
        let service = MockService(result: .success(mockResponse), delay: 0)
        let viewModel = MarketSummaryViewModel(service: service)
        await viewModel.fetchMarketData()

        viewModel.searchText = ""

        #expect(viewModel.filteredMarkets.count == MarketItem.mockData.count)
    }

    @MainActor @Test
    func testFilterWithMatchingSearchText() async throws {
        let viewModel = MarketSummaryViewModel()
        await viewModel.fetchMarketData()

        viewModel.searchText = MarketItem.mockData.first?.shortName ?? ""

        #expect(viewModel.filteredMarkets.count == 1)
    }

    @MainActor @Test
    func testFilterWithNoMatchingSearchText() async throws {
        let viewModel = MarketSummaryViewModel()
        await viewModel.fetchMarketData()

        viewModel.searchText = "Random Item"

        #expect(viewModel.filteredMarkets.isEmpty)
    }
}

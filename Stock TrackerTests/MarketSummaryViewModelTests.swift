//
//  MarketSummaryViewModelTests.swift
//  Stock TrackerTests
//
//  Created by Sylvan  on 15/04/2025.
//

import Testing
@testable import Stock_Tracker

struct MarketSummaryViewModelTests {

    struct MockService: MarketItemsService {
        let result: Result<Stock_Tracker.MarketSummaryResponse, Error>

        func fetchMarketItems() async -> Result<Stock_Tracker.MarketSummaryResponse, any Error> {
            return result
        }
        
        func fetchSummary(for symbols: [String]) async -> Result<Stock_Tracker.QuoteResponse, any Error> {
            fatalError("Not needed for now")
        }
    }

    @Test
    func testInitialMockDataLoaded() async throws {
        let viewModel = await MarketSummaryViewModel(useMockData: true)
        await viewModel.fetchMarketData()

        await #expect(viewModel.filteredMarkets.count == MarketItem.mockData.count)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
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
        let service = MockService(result: .success(mockResponse))
        let viewModel = await MarketSummaryViewModel(service: service, useMockData: false)

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
        let service = MockService(result: .success(mockResponse))
        let viewModel = await MarketSummaryViewModel(service: service, useMockData: false)

        await viewModel.fetchMarketData()

        await #expect(viewModel.filteredMarkets.isEmpty)
        await #expect(viewModel.errorMessage == error)
        await #expect(viewModel.isLoading == false)
    }

    @Test
    func testAPIError() async throws {
        let error = APIError.noData
        let service = MockService(result: .failure(error))
        let viewModel = await MarketSummaryViewModel(service: service, useMockData: false)

        await viewModel.fetchMarketData()

        await #expect(viewModel.filteredMarkets.isEmpty)
        await #expect(viewModel.errorMessage == error.localizedDescription)
        await #expect(viewModel.isLoading == false)
    }

    @MainActor @Test
    func testFilterWithEmptySearchText() async throws {
        let viewmodel = MarketSummaryViewModel(useMockData: true)
        await viewmodel.fetchMarketData()

        viewmodel.searchText = ""

        #expect(viewmodel.filteredMarkets.count == MarketItem.mockData.count)
    }

    @MainActor @Test
    func testFilterWithMatchingSearchText() async throws {
        let viewmodel = MarketSummaryViewModel(useMockData: true)
        await viewmodel.fetchMarketData()

        viewmodel.searchText = MarketItem.mockData.first?.shortName ?? ""

        #expect(viewmodel.filteredMarkets.count == 1)
    }

    @MainActor @Test
    func testFilterWithNoMatchingSearchText() async throws {
        let viewmodel = MarketSummaryViewModel(useMockData: true)
        await viewmodel.fetchMarketData()

        viewmodel.searchText = "Random Item"

        #expect(viewmodel.filteredMarkets.isEmpty)
    }
}

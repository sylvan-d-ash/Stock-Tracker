//
//  MarketItemDetailsViewModelTests.swift
//  Stock TrackerTests
//
//  Created by Sylvan  on 17/04/2025.
//

import Foundation
import Testing
@testable import Stock_Tracker

struct MarketItemDetailsViewModelTests {
    @Test
    func testSuccessResponse() async throws {
        let response = QuoteResponse(result: [QuoteSummary.mockData], error: nil)
        let service = MockService()
        service.summaryResult = .success(response)

        let viewModel = await MarketItemDetailsViewModel(item: MarketItem.mockData[0], service: service)

        await viewModel.fetchSummary()

        await #expect(viewModel.summary != nil)
        await #expect(viewModel.summary?.symbol == "AAPL")
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testErrorInAPIResponse() async throws {
        let error = "An error occurred."
        let response = QuoteResponse(result: [], error: error)
        let service = MockService()
        service.summaryResult = .success(response)

        let viewModel = await MarketItemDetailsViewModel(item: MarketItem.mockData[0], service: service)

        await viewModel.fetchSummary()

        await #expect(viewModel.summary == nil)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == error)
    }

    @Test
    func testFailureInAPI() async throws {
        let service = MockService()
        let viewModel = await MarketItemDetailsViewModel(item: MarketItem.mockData[0], service: service)
        
        await viewModel.fetchSummary()

        await #expect(viewModel.summary == nil)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == APIError.noData.localizedDescription)
    }

    @MainActor @Test
    func testNoDataFetchWhenAlreadyLoading() async throws {
        let service = MockService()
        let viewModel = MarketItemDetailsViewModel(item: MarketItem.mockData[0], service: service)
        
        viewModel.isLoading = true
        await viewModel.fetchSummary()
        
        #expect(viewModel.summary == nil)
        #expect(viewModel.isLoading == true)
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testIsLoadingIsToggledDuringFetch() async throws {
        let service = MockService()
        service.delay = 0.1 // small delay
        let viewModel = await MarketItemDetailsViewModel(item: MarketItem.mockData[0], service: service)

        await viewModel.fetchSummary()

        // assert initial state
        await #expect(viewModel.isLoading == false)

        // act
        let task = Task {
            await viewModel.fetchSummary()
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
}

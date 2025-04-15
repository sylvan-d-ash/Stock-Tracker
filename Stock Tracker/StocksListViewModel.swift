//
//  StocksListViewModel.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation
import Combine

class StocksListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var markets: [MarketItem] = []

//    private let baseURL = URL(string: "https://api.iextrading.com/1.0/stock/market/updates")!
    private let urlString = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-summary?region=US"
    private var useMockData = true

    func fetchMarketData() {
        if useMockData {
            self.markets = MarketItem.mockData
            return
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        isLoading = true

        let headers = [
            "x-rapidapi-key": "API-KEY-HERE", // TODO: load from secrets config file
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else { return }

                do {
                    let response = try JSONDecoder().decode(MarketSummaryResponse.self, from: data)
                    self.markets = response.marketSummaryAndSparkResponse.result
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}


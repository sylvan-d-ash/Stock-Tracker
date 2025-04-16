//
//  MarketSummaryView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 15/04/2025.
//

import SwiftUI

struct MarketSummaryView: View {
    @StateObject private var viewModel = MarketSummaryViewModel()

    var body: some View {
        NavigationView {
            List {
                MarketSummaryHeaderView()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))

                
                if viewModel.isLoading {
                    ProgressView()
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.markets, id: \.symbol) { item in
                        MarketItemRow(item: item)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    }
                }
            }
            .navigationTitle("Market Summary")
            .task {
                await viewModel.fetchMarketData()
            }
        }
    }
}

#Preview {
    MarketSummaryView()
        .environment(\.colorScheme, .dark) // Toggle this to switch between Light and Dark mode
}

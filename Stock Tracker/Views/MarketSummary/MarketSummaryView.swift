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
        NavigationStack {
            List {
                MarketSummaryHeaderView()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))

                if viewModel.isLoading {
                    ProgressView()
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.filteredMarkets, id: \.symbol) { item in
                        ZStack {
                            NavigationLink(value: item) {
                                EmptyView()
                            }
                            .opacity(0)

                            MarketItemRow(item: item)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    }
                }
            }
            .navigationTitle("Market Summary")
            .task {
                await viewModel.fetchMarketData()
            }
            .navigationDestination(for: MarketItem.self) { item in
                MarketItemDetailsView(item: item)
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Market")
        }
    }
}

#Preview {
    MarketSummaryView()
        .environment(\.colorScheme, .dark) // Toggle this to switch between Light and Dark mode
}

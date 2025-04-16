//
//  MarketItemDetailsView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import SwiftUI

struct MarketItemDetailsView: View {
    @StateObject private var viewModel: MarketItemDetailsViewModel
    private let item: MarketItem

    init(item: MarketItem) {
        self.item = item
        _viewModel = .init(wrappedValue: .init(item: item))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let summary = viewModel.summary {
                    MarketItemDetailsHeaderView(summary: summary)

                    Divider()

                    MarketItemDetailsStatsView(summary: summary)
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(item.shortName) (\(item.symbol))")
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .task {
                await viewModel.fetchSummary()
            }
        }
    }
}

#Preview {
    MarketItemDetailsView(item: MarketItem.mockData[0])
}

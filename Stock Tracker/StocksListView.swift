//
//  StocksListView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 15/04/2025.
//

import SwiftUI

struct MarketItemRow: View {
    @State var item: MarketItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.symbol)
                    .font(.subheadline)
                    .foregroundStyle(Color.blue)

                Text(item.shortName)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }

            Spacer()

            Text(item.quoteType)
                .font(.caption)
                .frame(width: 75, alignment: .leading)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text("$\(item.regularMarketPrice?.fmt ?? "--")")
                .font(.caption)
                .bold()
                .frame(width: 75.0, alignment: .trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            HStack(spacing: 4) {
                Image(systemName: item.change > 0 ? "arrow.up.right" : item.change < 0 ? "arrow.down.right" : "minus")

                Text(String(format: "%.2f%%", item.change))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(width: 75.0)
            .font(.caption)
            .foregroundStyle((item.change > 0) ? Color.green : (item.change < 0 ? Color.red : Color.gray))
        }
        .padding(.vertical, 6)
    }
}

struct StocksListView: View {
    @StateObject private var viewModel = StocksListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.markets, id: \.symbol) { item in
                if viewModel.isLoading {
                    ProgressView()
                        .listRowBackground(Color.clear)
                } else {
                    MarketItemRow(item: item)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
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
    StocksListView()
}

#Preview {
    MarketItemRow(item: MarketItem.mockData[0])
}

//
//  StocksListView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 15/04/2025.
//

import SwiftUI

struct StocksListView: View {
    @StateObject private var viewModel = StocksListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.markets, id: \.symbol) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.symbol)
                            .font(.headline)
                        Text(item.shortName)
                            .font(.subheadline)
                            .foregroundStyle(Color.gray)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text(item.regularMarketPrice?.fmt ?? "--")
                            .font(.subheadline)
                            .bold()

                        HStack(spacing: 4) {
                            Image(systemName: item.change > 0 ? "arrow.up.right" : item.change < 0 ? "arrow.down.right" : "minus")

                            Text(String(format: "%.2f%%", item.change))
                        }
                        .font(.caption)
                        .foregroundStyle((item.change > 0) ? Color.green : (item.change < 0 ? Color.red : Color.gray))
                    }
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("Market Summary")
            .onAppear {
                viewModel.fetchMarketData()
            }
        }
    }
}

#Preview {
    StocksListView()
}

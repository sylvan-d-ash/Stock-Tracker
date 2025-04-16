//
//  MarketItemDetailsView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import SwiftUI

struct StatItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .foregroundStyle(Color.secondary)

            Text(value)
        }
        .font(.caption)
    }
}

extension Double {
    func roundedToTwoDecimalString() -> String {
        let value = ceil(self * 100) / 100
        return String(format: "%.2f", value)
    }

    func asPercentageString() -> String {
        return "\(self > 0 ? "+" : "")" + self.roundedToTwoDecimalString() + "%"
    }
}

extension TimeInterval {
    func asDateString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }

    func asDateTimeString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MMM d h:mm:ss a"
        return dateFormatter.string(from: date)
    }

    func asTimeString(with offsetMilliseconds: Int) -> String {
        let interval = self + TimeInterval(offsetMilliseconds / 1000)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a"
        return dateFormatter.string(from: date)
    }
}

extension Int {
    func formattedMarketCap() -> String {
        let number = Double(self)

        switch number {
        case 1_000_000_000_000...:
            return String(format: "%.2fT", number / 1_000_000_000_000)
        case 1_000_000_000...:
            return String(format: "%.2fB", number / 1_000_000_000)
        case 1_000_000...:
            return String(format: "%.2fM", number / 1_000_000)
        default:
            return String(format: "%.0f", number) // No suffix for numbers below 1M
        }
    }
}

struct MarketItemDetailsHeaderView: View {
    @State var summary: QuoteSummary

    var body: some View {
        HStack(alignment: .top,spacing: 4) {
            VStack {
                Text(summary.regularMarketPrice.roundedToTwoDecimalString())
                    .font(.system(size: 40, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                Text("\(summary.regularMarketChange.roundedToTwoDecimalString()) (\(summary.regularMarketChangePercent.asPercentageString()))")
                    .foregroundStyle(summary.regularMarketChange > 0 ? Color.green : Color.red)

                Text("At close: \(summary.regularMarketTime.asDateTimeString(with: summary.gmtOffSetMilliseconds)) \(summary.exchangeTimezoneShortName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }

            Spacer()

            VStack {
                Text(summary.preMarketPrice.roundedToTwoDecimalString())
                    .font(.system(size: 40, weight: .bold))

                Text("\(summary.preMarketChange.roundedToTwoDecimalString()) (\(summary.preMarketChangePercent.asPercentageString()))")
                    .foregroundStyle(summary.preMarketChange > 0 ? Color.green : Color.red)

                Text("Pre-Market: \(summary.preMarketTime.asTimeString(with: summary.gmtOffSetMilliseconds)) \(summary.exchangeTimezoneShortName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
    }
}

struct MarketItemDetailsStatsView: View {
    @State var summary: QuoteSummary

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                StatItem(title: "Previous Close", value: summary.regularMarketPreviousClose.roundedToTwoDecimalString())
                StatItem(title: "Open", value: summary.regularMarketOpen.roundedToTwoDecimalString())
                StatItem(title: "Bid", value: "\(summary.bid.roundedToTwoDecimalString()) x \(summary.bidLot)")
                StatItem(title: "Ask", value: "\(summary.ask) x \(summary.askLot)")
                StatItem(title: "Day's Range", value: "\(summary.regularMarketDayLow.roundedToTwoDecimalString()) - \(summary.regularMarketDayHigh.roundedToTwoDecimalString())")
                StatItem(title: "52 Week Range", value: "\(summary.fiftyTwoWeekLow.roundedToTwoDecimalString()) - \(summary.fiftyTwoWeekHigh.roundedToTwoDecimalString())")
                StatItem(title: "Volume", value: summary.regularMarketVolume.formatted())
                StatItem(title: "Avg. Volume", value: summary.averageDailyVolume3Month.formatted())
            }

            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                StatItem(title: "Market Cap", value: summary.marketCap.formattedMarketCap())
                StatItem(title: "Beta (5Y Monthly)", value: summary.beta.roundedToTwoDecimalString())
                StatItem(title: "PE Ratio (TTM)", value: summary.trailingPE.roundedToTwoDecimalString())
                StatItem(title: "EPS (TTM)", value: summary.epsTrailingTwelveMonths.roundedToTwoDecimalString())
                StatItem(title: "Earnings Date", value: summary.earningsTimestamp.asDateString(with: summary.gmtOffSetMilliseconds))
                StatItem(title: "Forward Dividend & Yield", value: "\(summary.dividendRate?.roundedToTwoDecimalString() ?? "--") (\(summary.dividendYield?.asPercentageString() ?? "--"))")
                StatItem(title: "Ex-Dividend Date", value: "Feb 10, 2025")
                StatItem(title: "1y Target Est", value: summary.targetPriceMean.roundedToTwoDecimalString())
            }
        }
    }
}

struct MarketItemDetailsView: View {
    @StateObject private var viewModel: MarketItemDetailsViewModel
    private let item: MarketItem

    init(item: MarketItem) {
        self.item = item
        _viewModel = .init(wrappedValue: .init(item: item))
    }

    var body: some View {
        NavigationView {
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
}

#Preview {
    MarketItemDetailsView(item: MarketItem.mockData[0])
        .environment(\.colorScheme, .dark)
}

//
//  MarketItemDetailsStatsView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 17/04/2025.
//

import SwiftUI

private struct StatItem: View {
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

#Preview {
    MarketItemDetailsStatsView(summary: QuoteSummary.mockData)
}

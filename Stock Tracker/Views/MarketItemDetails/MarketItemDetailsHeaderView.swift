//
//  MarketItemDetailsHeaderView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 17/04/2025.
//

import SwiftUI

struct MarketItemDetailsHeaderView: View {
    @State var summary: QuoteSummary

    var body: some View {
        HStack(alignment: .top,spacing: 4) {
            if summary.preMarketPrice == nil {
                Spacer()
            }

            VStack {
                Text(summary.regularMarketPrice?.roundedToTwoDecimalString() ?? "--")
                    .font(.system(size: 40, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                Text("\(summary.regularMarketChange?.roundedToTwoDecimalString() ?? "--") (\(summary.regularMarketChangePercent?.asPercentageString() ?? "--"))")
                    .foregroundStyle(
                        (summary.regularMarketChange ?? 0) > 0 ? Color.green
                        : (summary.regularMarketChange ?? 0) < 0 ? Color.red : Color.secondary
                    )

                Text("At close: \(summary.regularMarketTime?.asDateTimeString(with: summary.gmtOffSetMilliseconds) ?? "--") \(summary.exchangeTimezoneShortName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }

            Spacer()

            if summary.preMarketPrice != nil {
                VStack {
                    Text(summary.preMarketPrice?.roundedToTwoDecimalString() ?? "--")
                        .font(.system(size: 40, weight: .bold))

                    Text("\(summary.preMarketChange?.roundedToTwoDecimalString() ?? "--") (\(summary.preMarketChangePercent?.asPercentageString() ?? "--"))")
                        .foregroundStyle(
                            (summary.preMarketChange ?? 0) > 0 ? Color.green
                            : (summary.preMarketChange ?? 0) < 0 ? Color.red : Color.secondary
                        )

                    Text("Pre-Market: \(summary.preMarketTime?.asTimeString(with: summary.gmtOffSetMilliseconds) ?? "--") \(summary.exchangeTimezoneShortName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }
}

#Preview {
    MarketItemDetailsHeaderView(summary: QuoteSummary.mockData)
}

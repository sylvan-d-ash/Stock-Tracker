//
//  MarketSummaryHeaderView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import SwiftUI

struct MarketSummaryHeaderView: View {
    var body: some View {
        HStack {
            Text("Name")

            Spacer()

            Text("Type")
                .frame(width: 75, alignment: .leading)

            Text("Price")
                .frame(width: 75, alignment: .trailing)

            Text("Change")
                .frame(width: 75, alignment: .center)
        }
        .font(.caption)
        .bold()
    }
}

#Preview {
    MarketSummaryHeaderView()
}

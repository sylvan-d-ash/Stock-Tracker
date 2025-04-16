//
//  MarketItemChartView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 17/04/2025.
//

import SwiftUI
import Charts

private struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

struct MarketItemChartView: View {
    let item: MarketItem

    private var data: [ChartDataPoint] {
        zip(item.spark.timestamp, item.spark.close).map {
            ChartDataPoint(date: Date(timeIntervalSince1970: $0), price: $1)
        }
    }

    var body: some View {
        Chart(data) { entry in
            LineMark(
                x: .value("Time", entry.date),
                y: .value("Price", entry.price)
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis {
            AxisMarks()
        }
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                AxisValueLabel()
                    .foregroundStyle(Color.secondary)
                AxisGridLine()
                    .foregroundStyle(Color.secondary)
                AxisTick()
            }
        }
        .chartYScale(domain: priceRange())
        .frame(height: 200)
    }

    private func priceRange() -> ClosedRange<Double> {
        guard let min = item.spark.close.min(), let max = item.spark.close.max() else {
            return 0...1
        }
        return Double(Int(min))...Double(Int(max))
    }
}

#Preview {
    MarketItemChartView(item: MarketItem.mockData[0])
}

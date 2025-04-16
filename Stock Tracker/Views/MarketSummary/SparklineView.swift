//
//  SparklineView.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import SwiftUI

private struct SparklineData: Identifiable {
    let id = UUID()
    let closeValues: [Double]

    var isRising: Bool {
        guard let first = closeValues.first, let last = closeValues.last else { return false }
        return last > first
    }
}

private struct SparklineChart: View {
    let data: SparklineData

    private func normalizedPoints(_ geometry: GeometryProxy) -> [CGPoint] {
        guard let min = data.closeValues.min(), let max = data.closeValues.max(), max != min else {
            return []
        }

        return data.closeValues.enumerated().map { index, value in
            let x = geometry.size.width * CGFloat(index) / CGFloat(data.closeValues.count - 1)
            let y = geometry.size.height * (1 - CGFloat((value - min) / (max - min)))
            return CGPoint(x: x, y: y)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let points = normalizedPoints(geometry)
            let gradientColor = data.isRising ? Color.green : Color.red

            ZStack {
                if points.count > 1 {
                    // Gradient Area Under Curve
                    Path { path in
                        path.move(to: points[0])
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                        path.addLine(to: CGPoint(x: points.last!.x, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: points[0].x, y: geometry.size.height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [gradientColor.opacity(0.3), gradientColor.opacity(0)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    // Sparkline Stroke
                    Path { path in
                        path.move(to: points[0])
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(gradientColor, lineWidth: 2)
                }
            }
        }
    }
}

struct SparklineView: View {
    @State var close: [Double]

    var body: some View {
        SparklineChart(data: SparklineData(closeValues: close))
            .frame(width: 75, height: 15.0)
            .padding()
    }
}

#Preview {
    let exampleCloseValues: [Double] = [
        5378.25, 5378.25, 5378.0, 5378.75, 5379.0, 5380.0, 5379.5,
        5380.0, 5377.5, 5374.75, 5376.25, 5370.0, 5367.5, 5368.0,
        5388.0, 5386.75
    ]

    SparklineView(close: exampleCloseValues)
}

import SwiftUI
import Charts

struct PerformanceChartView: View {
    let snapshots: [PerformanceSnapshot]

    private var chartData: [ChartDataPoint] {
        snapshots
            .sorted { $0.date < $1.date }
            .map { ChartDataPoint(date: $0.date, value: $0.totalValue) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if chartData.isEmpty {
                Text("No performance data")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Chart(chartData) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(.green)
                    .lineStyle(StrokeStyle(lineWidth: 2))

                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.green.opacity(0.3), .green.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    PointMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(.green)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text(CurrencyFormatter.format(doubleValue))
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

#Preview {
    PerformanceChartView(snapshots: [])
        .frame(height: 200)
        .padding()
}

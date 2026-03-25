import SwiftUI
import Charts

struct AllocationChartView: View {
    let portfolio: Portfolio

    private var allocationData: [AllocationItem] {
        var sectorMap: [String: Double] = [:]

        for holding in portfolio.holdings {
            sectorMap[holding.sector, default: 0] += holding.currentValue
        }

        return sectorMap.map { AllocationItem(category: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if allocationData.isEmpty {
                Text("No holdings to display")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                Chart(allocationData) { item in
                    SectorMark(
                        angle: .value("Value", item.value),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Category", item.category))
                    .cornerRadius(4)
                }
                .frame(height: 200)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 8) {
                    ForEach(allocationData) { item in
                        HStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.7))
                                .frame(width: 8, height: 8)
                            Text(item.category)
                                .font(.caption)
                            Spacer()
                            Text(CurrencyFormatter.formatPercentage((item.value / portfolio.totalValue) * 100))
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

struct AllocationItem: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}

#Preview {
    AllocationChartView(portfolio: Portfolio(name: "Test"))
        .padding()
}

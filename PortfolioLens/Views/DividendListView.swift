import SwiftUI
import SwiftData

struct DividendListView: View {
    let holding: Holding

    var body: some View {
        List {
            if holding.dividendPayments.isEmpty {
                Text("No dividend payments")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(holding.dividendPayments.sorted(by: { $0.paymentDate > $1.paymentDate })) { dividend in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(dividend.paymentDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                            Text(holding.ticker)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(CurrencyFormatter.format(dividend.amount))
                            .font(.headline)
                    }
                }
            }
        }
        .navigationTitle("Dividend History")
    }
}

#Preview {
    NavigationStack {
        DividendListView(holding: Holding(ticker: "AAPL", shares: 10, averageCostBasis: 150))
    }
}

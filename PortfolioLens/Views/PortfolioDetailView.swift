import SwiftUI
import SwiftData

struct PortfolioDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var portfolio: Portfolio
    @State private var showingAddHolding = false
    @State private var showingExportSheet = false
    @State private var csvText = ""
    @State private var viewModel: PortfolioViewModel?

    var body: some View {
        List {
            Section {
                PortfolioSummaryView(portfolio: portfolio)
            }

            Section {
                AllocationChartView(portfolio: portfolio)
            } header: {
                Text("Asset Allocation")
            }

            Section {
                if !portfolio.snapshots.isEmpty {
                    PerformanceChartView(snapshots: portfolio.snapshots)
                        .frame(height: 200)
                } else {
                    Text("No performance data yet")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }

                Button {
                    createSnapshot()
                } label: {
                    Label("Create Snapshot", systemImage: "camera")
                }
            } header: {
                Text("Performance")
            }

            Section {
                ForEach(portfolio.holdings.sorted(by: { $0.ticker < $1.ticker })) { holding in
                    NavigationLink {
                        HoldingDetailView(holding: holding)
                    } label: {
                        HoldingRowView(holding: holding)
                    }
                }
            } header: {
                Text("Holdings")
            }
        }
        .navigationTitle(portfolio.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingAddHolding = true
                    } label: {
                        Label("Add Holding", systemImage: "plus")
                    }

                    Button {
                        exportToCSV()
                    } label: {
                        Label("Export CSV", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingAddHolding) {
            AddHoldingView(portfolio: portfolio)
        }
        .sheet(isPresented: $showingExportSheet) {
            ShareSheet(activityItems: [csvText])
        }
        .onAppear {
            viewModel = PortfolioViewModel(modelContext: modelContext)
        }
    }

    private func createSnapshot() {
        viewModel?.createSnapshot(for: portfolio)
    }

    private func exportToCSV() {
        csvText = CSVExporter.exportPortfolio(portfolio)
        showingExportSheet = true
    }
}

struct PortfolioSummaryView: View {
    let portfolio: Portfolio

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                StatView(title: "Total Value", value: CurrencyFormatter.format(portfolio.totalValue))
                Divider()
                StatView(title: "Total Cost", value: CurrencyFormatter.format(portfolio.totalCost))
            }
            .frame(height: 60)

            HStack {
                StatView(
                    title: "Gain/Loss",
                    value: CurrencyFormatter.format(portfolio.totalGainLoss),
                    valueColor: portfolio.totalGainLoss >= 0 ? .green : .red
                )
                Divider()
                StatView(
                    title: "Return",
                    value: CurrencyFormatter.formatPercentage(portfolio.totalGainLossPercentage),
                    valueColor: portfolio.totalGainLoss >= 0 ? .green : .red
                )
            }
            .frame(height: 60)

            HStack {
                StatView(title: "Annual Dividends", value: CurrencyFormatter.format(portfolio.annualDividendIncome))
                Divider()
                StatView(title: "Yield", value: CurrencyFormatter.formatPercentage(portfolio.dividendYield))
            }
            .frame(height: 60)
        }
        .padding(.vertical, 8)
    }
}

struct StatView: View {
    let title: String
    let value: String
    var valueColor: Color = .primary

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .foregroundStyle(valueColor)
        }
        .frame(maxWidth: .infinity)
    }
}

struct HoldingRowView: View {
    let holding: Holding

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(holding.ticker)
                    .font(.headline)
                Spacer()
                Text(CurrencyFormatter.format(holding.currentValue))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            HStack {
                Text("\(CurrencyFormatter.formatNumber(holding.shares)) shares @ \(CurrencyFormatter.format(holding.currentPrice))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(CurrencyFormatter.format(holding.gainLoss))
                    .font(.caption)
                    .foregroundStyle(holding.gainLoss >= 0 ? .green : .red)
                Text("(\(CurrencyFormatter.formatPercentage(holding.gainLossPercentage)))")
                    .font(.caption2)
                    .foregroundStyle(holding.gainLoss >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        PortfolioDetailView(portfolio: Portfolio(name: "Sample"))
    }
    .modelContainer(for: [Portfolio.self, Holding.self, DividendPayment.self, PerformanceSnapshot.self], inMemory: true)
}

import SwiftUI
import SwiftData

struct PortfolioListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Portfolio.name) private var portfolios: [Portfolio]
    @State private var showingAddPortfolio = false
    @State private var viewModel: PortfolioViewModel?

    var body: some View {
        NavigationStack {
            List {
                ForEach(portfolios) { portfolio in
                    NavigationLink {
                        PortfolioDetailView(portfolio: portfolio)
                    } label: {
                        PortfolioRowView(portfolio: portfolio)
                    }
                }
                .onDelete(perform: deletePortfolios)
            }
            .navigationTitle("Portfolios")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddPortfolio = true
                    } label: {
                        Label("Add Portfolio", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPortfolio) {
                AddPortfolioView()
            }
            .overlay {
                if portfolios.isEmpty {
                    ContentUnavailableView(
                        "No Portfolios",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Tap + to create your first portfolio")
                    )
                }
            }
        }
        .onAppear {
            viewModel = PortfolioViewModel(modelContext: modelContext)
        }
    }

    private func deletePortfolios(at offsets: IndexSet) {
        for index in offsets {
            viewModel?.deletePortfolio(portfolios[index])
        }
    }
}

struct PortfolioRowView: View {
    let portfolio: Portfolio

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(portfolio.name)
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Value")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(CurrencyFormatter.format(portfolio.totalValue))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Gain/Loss")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Text(CurrencyFormatter.format(portfolio.totalGainLoss))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("(\(CurrencyFormatter.formatPercentage(portfolio.totalGainLossPercentage)))")
                            .font(.caption)
                    }
                    .foregroundStyle(portfolio.totalGainLoss >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PortfolioListView()
        .modelContainer(for: [Portfolio.self, Holding.self, DividendPayment.self, PerformanceSnapshot.self], inMemory: true)
}

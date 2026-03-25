import SwiftUI
import SwiftData

struct HoldingDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var holding: Holding
    @State private var showingUpdatePrice = false
    @State private var showingAddDividend = false
    @State private var newPrice = ""
    @State private var isEditing = false
    @State private var editShares = ""
    @State private var editCostBasis = ""
    @State private var viewModel: HoldingViewModel?

    var body: some View {
        List {
            Section {
                HoldingSummaryView(holding: holding)
            }

            Section("Position Details") {
                LabeledContent("Ticker", value: holding.ticker)

                if isEditing {
                    HStack {
                        Text("Shares")
                        Spacer()
                        TextField("Shares", text: $editShares)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    HStack {
                        Text("Avg Cost Basis")
                        Spacer()
                        TextField("Cost", text: $editCostBasis)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                } else {
                    LabeledContent("Shares", value: CurrencyFormatter.formatNumber(holding.shares))
                    LabeledContent("Avg Cost Basis", value: CurrencyFormatter.format(holding.averageCostBasis))
                }

                LabeledContent("Current Price", value: CurrencyFormatter.format(holding.currentPrice))
                LabeledContent("Asset Type", value: holding.assetType)
                LabeledContent("Sector", value: holding.sector)
                LabeledContent("Last Updated", value: holding.lastUpdated.formatted(date: .abbreviated, time: .shortened))
            }

            Section("Dividends") {
                if holding.dividendPayments.isEmpty {
                    Text("No dividend payments recorded")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(holding.dividendPayments.sorted(by: { $0.paymentDate > $1.paymentDate })) { dividend in
                        HStack {
                            Text(dividend.paymentDate.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            Text(CurrencyFormatter.format(dividend.amount))
                                .fontWeight(.medium)
                        }
                    }

                    Divider()

                    LabeledContent("Annual Income", value: CurrencyFormatter.format(holding.annualDividendIncome))
                        .fontWeight(.semibold)
                    LabeledContent("Yield", value: CurrencyFormatter.formatPercentage(holding.dividendYield))
                        .fontWeight(.semibold)
                }

                Button {
                    showingAddDividend = true
                } label: {
                    Label("Add Dividend Payment", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle(holding.ticker)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        if isEditing {
                            saveChanges()
                        }
                        isEditing.toggle()
                    } label: {
                        Label(isEditing ? "Save" : "Edit", systemImage: isEditing ? "checkmark" : "pencil")
                    }

                    Button {
                        showingUpdatePrice = true
                    } label: {
                        Label("Update Price", systemImage: "dollarsign.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Update Price", isPresented: $showingUpdatePrice) {
            TextField("New Price", text: $newPrice)
                .keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) {}
            Button("Update") {
                updatePrice()
            }
        }
        .sheet(isPresented: $showingAddDividend) {
            AddDividendView(holding: holding)
        }
        .onAppear {
            viewModel = HoldingViewModel(modelContext: modelContext)
            editShares = String(holding.shares)
            editCostBasis = String(holding.averageCostBasis)
        }
    }

    private func updatePrice() {
        guard let price = Double(newPrice) else { return }
        holding.currentPrice = price
        viewModel?.updateHolding(holding)
        newPrice = ""
    }

    private func saveChanges() {
        if let shares = Double(editShares) {
            holding.shares = shares
        }
        if let costBasis = Double(editCostBasis) {
            holding.averageCostBasis = costBasis
        }
        viewModel?.updateHolding(holding)
    }
}

struct HoldingSummaryView: View {
    let holding: Holding

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                StatView(title: "Total Cost", value: CurrencyFormatter.format(holding.totalCost))
                Divider()
                StatView(title: "Current Value", value: CurrencyFormatter.format(holding.currentValue))
            }
            .frame(height: 60)

            HStack {
                StatView(
                    title: "Gain/Loss",
                    value: CurrencyFormatter.format(holding.gainLoss),
                    valueColor: holding.gainLoss >= 0 ? .green : .red
                )
                Divider()
                StatView(
                    title: "Return",
                    value: CurrencyFormatter.formatPercentage(holding.gainLossPercentage),
                    valueColor: holding.gainLoss >= 0 ? .green : .red
                )
            }
            .frame(height: 60)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        HoldingDetailView(holding: Holding(ticker: "AAPL", shares: 10, averageCostBasis: 150, currentPrice: 180))
    }
    .modelContainer(for: [Holding.self, DividendPayment.self], inMemory: true)
}

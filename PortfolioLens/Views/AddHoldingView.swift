import SwiftUI
import SwiftData

struct AddHoldingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let portfolio: Portfolio

    @State private var ticker = ""
    @State private var shares = ""
    @State private var averageCostBasis = ""
    @State private var currentPrice = ""
    @State private var assetType = "Stock"
    @State private var sector = "Technology"
    @State private var viewModel: HoldingViewModel?

    let assetTypes = ["Stock", "ETF", "Bond", "Crypto", "Commodity", "Real Estate", "Other"]
    let sectors = ["Technology", "Healthcare", "Financial", "Consumer", "Energy", "Industrials", "Materials", "Real Estate", "Utilities", "Communication", "Other"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Ticker") {
                    TextField("Symbol", text: $ticker)
                        .textInputAutocapitalization(.characters)
                }

                Section("Shares") {
                    TextField("Number of Shares", text: $shares)
                        .keyboardType(.decimalPad)
                }

                Section("Cost Basis") {
                    TextField("Average Cost per Share", text: $averageCostBasis)
                        .keyboardType(.decimalPad)
                }

                Section("Current Price") {
                    TextField("Current Price per Share", text: $currentPrice)
                        .keyboardType(.decimalPad)
                }

                Section("Classification") {
                    Picker("Asset Type", selection: $assetType) {
                        ForEach(assetTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    Picker("Sector", selection: $sector) {
                        ForEach(sectors, id: \.self) { sec in
                            Text(sec).tag(sec)
                        }
                    }
                }
            }
            .navigationTitle("Add Holding")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addHolding()
                    }
                    .disabled(!isValid)
                }
            }
        }
        .onAppear {
            viewModel = HoldingViewModel(modelContext: modelContext)
        }
    }

    private var isValid: Bool {
        !ticker.isEmpty &&
        Double(shares) != nil &&
        Double(averageCostBasis) != nil &&
        Double(currentPrice) != nil
    }

    private func addHolding() {
        guard let sharesValue = Double(shares),
              let costBasisValue = Double(averageCostBasis),
              let priceValue = Double(currentPrice) else {
            return
        }

        viewModel?.createHolding(
            portfolio: portfolio,
            ticker: ticker,
            shares: sharesValue,
            averageCostBasis: costBasisValue,
            currentPrice: priceValue,
            assetType: assetType,
            sector: sector
        )
        dismiss()
    }
}

#Preview {
    AddHoldingView(portfolio: Portfolio(name: "Test"))
        .modelContainer(for: [Portfolio.self, Holding.self], inMemory: true)
}

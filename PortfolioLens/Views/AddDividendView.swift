import SwiftUI
import SwiftData

struct AddDividendView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let holding: Holding

    @State private var amount = ""
    @State private var paymentDate = Date()
    @State private var viewModel: HoldingViewModel?

    var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    TextField("Dividend Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }

                Section("Date") {
                    DatePicker("Payment Date", selection: $paymentDate, displayedComponents: [.date])
                }
            }
            .navigationTitle("Add Dividend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addDividend()
                    }
                    .disabled(amount.isEmpty || Double(amount) == nil)
                }
            }
        }
        .onAppear {
            viewModel = HoldingViewModel(modelContext: modelContext)
        }
    }

    private func addDividend() {
        guard let amountValue = Double(amount) else { return }
        viewModel?.addDividend(to: holding, amount: amountValue, paymentDate: paymentDate)
        dismiss()
    }
}

#Preview {
    AddDividendView(holding: Holding(ticker: "AAPL", shares: 10, averageCostBasis: 150))
        .modelContainer(for: [Holding.self, DividendPayment.self], inMemory: true)
}

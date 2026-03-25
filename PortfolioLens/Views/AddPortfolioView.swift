import SwiftUI
import SwiftData

struct AddPortfolioView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var viewModel: PortfolioViewModel?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Portfolio Name", text: $name)
                } header: {
                    Text("Details")
                } footer: {
                    Text("e.g., Retirement, Trading, Crypto")
                }
            }
            .navigationTitle("New Portfolio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addPortfolio()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            viewModel = PortfolioViewModel(modelContext: modelContext)
        }
    }

    private func addPortfolio() {
        viewModel?.createPortfolio(name: name)
        dismiss()
    }
}

#Preview {
    AddPortfolioView()
        .modelContainer(for: [Portfolio.self], inMemory: true)
}

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        PortfolioListView()
            .environment(\.modelContext, modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Portfolio.self, Holding.self, DividendPayment.self, PerformanceSnapshot.self], inMemory: true)
}

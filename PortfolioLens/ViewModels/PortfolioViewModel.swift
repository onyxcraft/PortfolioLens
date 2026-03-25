import Foundation
import SwiftData

@Observable
class PortfolioViewModel {
    var modelContext: ModelContext?

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }

    func createPortfolio(name: String) {
        let portfolio = Portfolio(name: name)
        modelContext?.insert(portfolio)
        try? modelContext?.save()
    }

    func deletePortfolio(_ portfolio: Portfolio) {
        modelContext?.delete(portfolio)
        try? modelContext?.save()
    }

    func updatePortfolio(_ portfolio: Portfolio) {
        try? modelContext?.save()
    }

    func createSnapshot(for portfolio: Portfolio) {
        let snapshot = PerformanceSnapshot(
            date: Date(),
            totalValue: portfolio.totalValue,
            totalCost: portfolio.totalCost
        )
        snapshot.portfolio = portfolio
        portfolio.snapshots.append(snapshot)
        modelContext?.insert(snapshot)
        try? modelContext?.save()
    }

    func deleteSnapshot(_ snapshot: PerformanceSnapshot) {
        modelContext?.delete(snapshot)
        try? modelContext?.save()
    }
}

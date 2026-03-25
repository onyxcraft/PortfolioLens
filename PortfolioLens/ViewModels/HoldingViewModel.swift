import Foundation
import SwiftData

@Observable
class HoldingViewModel {
    var modelContext: ModelContext?

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }

    func createHolding(portfolio: Portfolio, ticker: String, shares: Double, averageCostBasis: Double, currentPrice: Double, assetType: String, sector: String) {
        let holding = Holding(
            ticker: ticker,
            shares: shares,
            averageCostBasis: averageCostBasis,
            currentPrice: currentPrice,
            assetType: assetType,
            sector: sector
        )
        holding.portfolio = portfolio
        portfolio.holdings.append(holding)
        modelContext?.insert(holding)
        try? modelContext?.save()
    }

    func updateHolding(_ holding: Holding) {
        holding.lastUpdated = Date()
        try? modelContext?.save()
    }

    func deleteHolding(_ holding: Holding) {
        modelContext?.delete(holding)
        try? modelContext?.save()
    }

    func addDividend(to holding: Holding, amount: Double, paymentDate: Date) {
        let dividend = DividendPayment(amount: amount, paymentDate: paymentDate)
        dividend.holding = holding
        holding.dividendPayments.append(dividend)
        modelContext?.insert(dividend)
        try? modelContext?.save()
    }

    func deleteDividend(_ dividend: DividendPayment) {
        modelContext?.delete(dividend)
        try? modelContext?.save()
    }
}

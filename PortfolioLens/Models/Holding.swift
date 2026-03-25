import Foundation
import SwiftData

@Model
final class Holding {
    var id: UUID
    var ticker: String
    var shares: Double
    var averageCostBasis: Double
    var currentPrice: Double
    var assetType: String
    var sector: String
    var lastUpdated: Date
    var dividendPayments: [DividendPayment]
    var portfolio: Portfolio?

    init(ticker: String, shares: Double, averageCostBasis: Double, currentPrice: Double = 0, assetType: String = "Stock", sector: String = "Other") {
        self.id = UUID()
        self.ticker = ticker.uppercased()
        self.shares = shares
        self.averageCostBasis = averageCostBasis
        self.currentPrice = currentPrice
        self.assetType = assetType
        self.sector = sector
        self.lastUpdated = Date()
        self.dividendPayments = []
    }

    var totalCost: Double {
        shares * averageCostBasis
    }

    var currentValue: Double {
        shares * currentPrice
    }

    var gainLoss: Double {
        currentValue - totalCost
    }

    var gainLossPercentage: Double {
        guard totalCost > 0 else { return 0 }
        return (gainLoss / totalCost) * 100
    }

    var annualDividendIncome: Double {
        let calendar = Calendar.current
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        return dividendPayments
            .filter { $0.paymentDate >= oneYearAgo }
            .reduce(0) { $0 + $1.amount }
    }

    var dividendYield: Double {
        guard currentValue > 0 else { return 0 }
        return (annualDividendIncome / currentValue) * 100
    }
}

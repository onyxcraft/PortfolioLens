import Foundation
import SwiftData

@Model
final class Portfolio {
    var id: UUID
    var name: String
    var createdDate: Date
    var holdings: [Holding]
    var snapshots: [PerformanceSnapshot]

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdDate = Date()
        self.holdings = []
        self.snapshots = []
    }

    var totalValue: Double {
        holdings.reduce(0) { $0 + $1.currentValue }
    }

    var totalCost: Double {
        holdings.reduce(0) { $0 + $1.totalCost }
    }

    var totalGainLoss: Double {
        totalValue - totalCost
    }

    var totalGainLossPercentage: Double {
        guard totalCost > 0 else { return 0 }
        return (totalGainLoss / totalCost) * 100
    }

    var annualDividendIncome: Double {
        holdings.reduce(0) { $0 + $1.annualDividendIncome }
    }

    var dividendYield: Double {
        guard totalValue > 0 else { return 0 }
        return (annualDividendIncome / totalValue) * 100
    }
}

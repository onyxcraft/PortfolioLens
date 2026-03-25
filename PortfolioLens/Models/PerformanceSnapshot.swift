import Foundation
import SwiftData

@Model
final class PerformanceSnapshot {
    var id: UUID
    var date: Date
    var totalValue: Double
    var totalCost: Double
    var portfolio: Portfolio?

    init(date: Date, totalValue: Double, totalCost: Double) {
        self.id = UUID()
        self.date = date
        self.totalValue = totalValue
        self.totalCost = totalCost
    }

    var gainLoss: Double {
        totalValue - totalCost
    }

    var gainLossPercentage: Double {
        guard totalCost > 0 else { return 0 }
        return (gainLoss / totalCost) * 100
    }
}

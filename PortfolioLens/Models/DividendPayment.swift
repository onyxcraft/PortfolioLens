import Foundation
import SwiftData

@Model
final class DividendPayment {
    var id: UUID
    var amount: Double
    var paymentDate: Date
    var holding: Holding?

    init(amount: Double, paymentDate: Date) {
        self.id = UUID()
        self.amount = amount
        self.paymentDate = paymentDate
    }
}

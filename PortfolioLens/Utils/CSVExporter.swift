import Foundation

struct CSVExporter {
    static func exportPortfolio(_ portfolio: Portfolio) -> String {
        var csv = "Ticker,Shares,Avg Cost Basis,Current Price,Total Cost,Current Value,Gain/Loss,Gain/Loss %,Asset Type,Sector\n"

        for holding in portfolio.holdings.sorted(by: { $0.ticker < $1.ticker }) {
            let row = [
                holding.ticker,
                String(format: "%.4f", holding.shares),
                String(format: "%.2f", holding.averageCostBasis),
                String(format: "%.2f", holding.currentPrice),
                String(format: "%.2f", holding.totalCost),
                String(format: "%.2f", holding.currentValue),
                String(format: "%.2f", holding.gainLoss),
                String(format: "%.2f", holding.gainLossPercentage),
                holding.assetType,
                holding.sector
            ].joined(separator: ",")
            csv += row + "\n"
        }

        csv += "\nPortfolio Summary\n"
        csv += "Total Cost,\(String(format: "%.2f", portfolio.totalCost))\n"
        csv += "Total Value,\(String(format: "%.2f", portfolio.totalValue))\n"
        csv += "Total Gain/Loss,\(String(format: "%.2f", portfolio.totalGainLoss))\n"
        csv += "Total Gain/Loss %,\(String(format: "%.2f", portfolio.totalGainLossPercentage))\n"
        csv += "Annual Dividend Income,\(String(format: "%.2f", portfolio.annualDividendIncome))\n"
        csv += "Dividend Yield %,\(String(format: "%.2f", portfolio.dividendYield))\n"

        return csv
    }

    static func exportDividends(_ holding: Holding) -> String {
        var csv = "Date,Amount\n"

        for dividend in holding.dividendPayments.sorted(by: { $0.paymentDate > $1.paymentDate }) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let row = [
                dateFormatter.string(from: dividend.paymentDate),
                String(format: "%.2f", dividend.amount)
            ].joined(separator: ",")
            csv += row + "\n"
        }

        csv += "\nTotal Annual Dividend Income,\(String(format: "%.2f", holding.annualDividendIncome))\n"
        csv += "Dividend Yield %,\(String(format: "%.2f", holding.dividendYield))\n"

        return csv
    }
}

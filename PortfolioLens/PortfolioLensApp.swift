import SwiftUI
import SwiftData

@main
struct PortfolioLensApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Portfolio.self,
            Holding.self,
            DividendPayment.self,
            PerformanceSnapshot.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

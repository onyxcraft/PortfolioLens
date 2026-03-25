import SwiftUI
import SwiftData

struct HoldingListView: View {
    let holdings: [Holding]

    var body: some View {
        ForEach(holdings) { holding in
            NavigationLink {
                HoldingDetailView(holding: holding)
            } label: {
                HoldingRowView(holding: holding)
            }
        }
    }
}

#Preview {
    HoldingListView(holdings: [])
}

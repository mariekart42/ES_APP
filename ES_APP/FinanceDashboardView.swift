

import SwiftUI

struct FinanceDashboardView: View {
    @StateObject var financeViewModel = FinanceViewModel()
    var body: some View {
        Text("Hallo, Finance View")
    }
}

struct FinanceDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            FinanceDashboardView()
                .preferredColorScheme(colorScheme)
        }
    }
}

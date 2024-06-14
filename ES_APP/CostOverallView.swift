
import SwiftUI

struct CostOverallView: View {
    @ObservedObject var financeViewModel: FinanceViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CostOverallView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            CostOverallView(financeViewModel: FinanceViewModel())
                .preferredColorScheme(colorScheme)
        }
    }
}

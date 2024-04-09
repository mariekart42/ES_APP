//
//  CostPeriodicalView.swift
//  My IP Port
//
//  Created by Julian Heiß on 31.05.22.
//

import SwiftUI

struct CostPeriodicalView: View {
    @ObservedObject var financeViewModel: FinanceViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CostPeriodicalView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            CostPeriodicalView(financeViewModel: FinanceViewModel())
                .preferredColorScheme(colorScheme)
        }
    }
}

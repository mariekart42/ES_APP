//
//  DeadlineFilterView.swift
//  My IP Port
//
//  Created by Dominik Remo on 17.07.22.
//

import SwiftUI

struct DeadlineFilterView: View {
    @EnvironmentObject private var deadlineViewModel: DeadlineViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                DeadlineFilterType().environmentObject(deadlineViewModel)
                VStack {
                    Button(action: {
                        deadlineViewModel.showFilter = false
                    }) {
                        Text("Filter anwenden")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal, 50)
                            .background(Color("Blue01"))
                            .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        deadlineViewModel.showFilter = false
                        deadlineViewModel.filterByType = false
                    }) {
                        Text("Reset")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal, 50)
                            .background(.gray)
                            .clipShape(Capsule())
                    }
                }
                .padding(40)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Text("  Filter")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(Color("HighlightText"))
                })
        }
    }
}

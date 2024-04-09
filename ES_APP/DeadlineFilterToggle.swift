//
//  DeadlineFilterToggle.swift
//  My IP Port
//
//  Created by Dominik Remo on 17.07.22.
//

import SwiftUI

struct DeadlineFilterToggle: View {
    /// The `FileViewModel` for this view and its subviews
    @EnvironmentObject var deadlineViewModel: DeadlineViewModel
    
    var body: some View {
        if deadlineViewModel.filterByType {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color("HighlightText"))
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "circle.circle.fill")
                        .resizable()
                        .foregroundColor(Color(UIColor.systemGreen))
                        .frame(width: 15, height: 15)
                        .offset(x: -5, y: 5)
                }
        } else {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color("HighlightText"))
        }
    }
}

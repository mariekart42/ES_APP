//
//  FilterToggleWithIndicator.swift
//  My IP Port
//
//  Created by Dominik Remo on 05.07.22.
//

import SwiftUI

struct FilterToggleWithIndicator: View {
    /// The `FileViewModel` for this view and its subviews
    @EnvironmentObject var fileViewModel: FileViewModel
    
    var body: some View {
        if fileViewModel.filterByCurrentState || fileViewModel.filterByCountry || fileViewModel.filterByDate {
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

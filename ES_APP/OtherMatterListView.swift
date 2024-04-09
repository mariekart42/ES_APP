//
//  OtherMatterListView.swift
//  My IP Port
//
//  Created by Julian Heiß on 31.05.22.
//

import SwiftUI


struct OtherMatterListView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    @State var families: [FileFamily] = []
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    init(_ families: [FileFamily]) {
        self.families = families
    }
}

/*
struct OtherMatterListView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            OtherMatterListView([]).environmentObject(FileViewModel(model))
                .preferredColorScheme(colorScheme)
        }
    }
}
*/

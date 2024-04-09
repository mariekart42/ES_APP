//
//  NewSonstigeView.swift
//  My IP Port
//
//  Created by Johannes Fuest on 18.07.22.
//

import Foundation
import SwiftUI

struct NewSonstigeView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    var newSonstige: [File]
    var body: some View {
        VStack {
            if newSonstige.isEmpty {
                Text("Sie haben aktuell keine neuen sonstigen Akten.").foregroundColor(.gray)
            } else {
                List {
                    ForEach(newSonstige, id: \.self) { patent in
                        NavigationLink(destination: FileView(patent, false).environmentObject(fileViewModel)) {
                            DetailsItemView(patent).environmentObject(fileViewModel)
                        }
                    }
                }.listStyle(.inset)
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Neue Sonstige Akten")
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color("HighlightText"))
            }
        }
    }
    
    init(newSonstige: [File]) {
        self.newSonstige = newSonstige
    }
}

struct NewSonstigeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NewPatentsView(newPatents: [])
                .preferredColorScheme(colorScheme)
        }
    }
}

//
//  FilesOfFamilyView.swift
//  My IP Port
//
//  Created by Julian Heiß on 31.05.22.
//

import SwiftUI

// list of patents, marks, designs of a specific family
struct FilesOfFamilyView: View {
    //@ObservedObject var filesViewModel: FileViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FilesOfFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            FilesOfFamilyView()
                .preferredColorScheme(colorScheme)
        }
    }
}

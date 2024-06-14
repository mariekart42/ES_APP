
import Foundation
import SwiftUI

struct NewDesignsView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    var newDesigns: [File]
    var body: some View {
        VStack {
            if newDesigns.isEmpty {
                Text("Sie haben aktuell keine neuen Designs.").foregroundColor(.gray)
            } else {
                List {
                    ForEach(newDesigns, id: \.self) { patent in
                        NavigationLink(destination: FileView(patent, false).environmentObject(fileViewModel)) {
                            DetailsItemView(patent).environmentObject(fileViewModel)
                        }
                    }
                }.listStyle(.inset)
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Neue Designs")
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color("HighlightText"))
            }
        }
    }
    
    init(newDesigns: [File]) {
        self.newDesigns = newDesigns
    }
}

struct NewDesignsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NewPatentsView(newPatents: [])
                .preferredColorScheme(colorScheme)
        }
    }
}

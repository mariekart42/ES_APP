
import Foundation
import SwiftUI

struct NewMarkenView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    var newBrands: [File]
    var body: some View {
        VStack {
            if newBrands.isEmpty {
                Text("Sie haben aktuell keine neuen Marken.").foregroundColor(.gray)
            } else {
                List {
                    ForEach(newBrands, id: \.self) { patent in
                        NavigationLink(destination: FileView(patent, false).environmentObject(fileViewModel)) {
                            DetailsItemView(patent).environmentObject(fileViewModel)
                        }
                    }
                }.listStyle(.inset)
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Neue Marken")
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color("HighlightText"))
            }
        }
    }
    
    init(newBrands: [File]) {
        self.newBrands = newBrands
    }
}

struct NewMarkenView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NewPatentsView(newPatents: [])
                .preferredColorScheme(colorScheme)
        }
    }
}

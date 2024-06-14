
import SwiftUI

struct NewGebrauchsmusterView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    var newGebrauchsmuster: [File]
    var body: some View {
        VStack {
            if newGebrauchsmuster.isEmpty {
                Text("Sie haben aktuell keine neuen Gebrauchsmuster.").foregroundColor(.gray)
            } else {
                List {
                    ForEach(newGebrauchsmuster, id: \.self) { patent in
                        NavigationLink(destination: FileView(patent, false).environmentObject(fileViewModel)) {
                            DetailsItemView(patent).environmentObject(fileViewModel)
                        }
                    }
                }.listStyle(.inset)
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Neue Gebrauchsmuster")
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color("HighlightText"))
            }
        }
    }
    
    init(newGebrauchsmuster: [File]) {
        self.newGebrauchsmuster = newGebrauchsmuster
    }
}

struct NewGebrauchsmusterView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NewPatentsView(newPatents: [])
                .preferredColorScheme(colorScheme)
        }
    }
}

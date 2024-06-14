
import SwiftUI

struct NewPatentsView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    @EnvironmentObject var dataViewModel: DataViewModel
    var newSonstige: [File]
    var body: some View {
            VStack {
                if newSonstige.isEmpty {
                    Text("Sie haben aktuell keine neuen Patente.").foregroundColor(.gray)
                } else {
                    List {
                        ForEach(newSonstige, id: \.self) { patent in
                            NavigationLink(destination: FileView(patent, false).environmentObject(fileViewModel).environmentObject(dataViewModel)) {
                                DetailsItemView(patent).environmentObject(fileViewModel)
                            }
                        }
                    }.listStyle(.inset)
                }
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Neue Patente")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(Color("HighlightText"))
                }
            }
        }
    
    init(newPatents: [File]) {
        self.newSonstige = newPatents
    }
}

struct NewPatentsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NewPatentsView(newPatents: [])
                .preferredColorScheme(colorScheme)
        }
    }
}


import SwiftUI

struct DetailsList: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    @EnvironmentObject var textViewModel: TextViewModel
    var family: FileFamily
    private var clientSym: String
    @State var text: String
    //swiftlint:disable closure_body_length
    var body: some View {
        VStack {
            if !clientSym.isEmpty {
                Text("\(clientSym)")
                Divider().background(.primary)
            }
            if let files = family.associatedFiles.allObjects as? [File] {
                let file: File = files.filter{ $0.id.contains(family.id) }.first!
            Text(file.matterType)
            }
            Divider().background(.primary)
            HStack(spacing: 5) {
                Image(systemName: "calendar")
                if family.registrationDate.timeIntervalSinceReferenceDate != 0 {
                    Text("Priorität: \(fileViewModel.getDate(date: family.registrationDate))")
                } else {
                    Text("Priorität: nicht vorhanden")
                }
            }
            Divider().background(.primary)
            VStack(alignment: .leading) {
                if family.matterType.contains("Design") || family.matterType.contains("Marke") {
                    Text("Angemeldet: \(fileViewModel.getRegisteredFilesCount(fileFamily: family))        davon eingetragen: \(fileViewModel.getIncorpartedCount(fileFamily: family))")
                } else {
                    VStack {
                        Text("Angemeldet: \(fileViewModel.getRegisteredFilesCount(fileFamily: family))        davon erteilt: \(fileViewModel.getIssuedPatentsCount(fileFamily: family))")
                        if family.matterType.contains("Gebrauchsmuster")
                            || fileViewModel.getIncorpartedCount(fileFamily: family) > 0 {
                            Text("davon eingetragen: \(fileViewModel.getIncorpartedCount(fileFamily: family))")
                        }
                    }
                }
            }
            Divider().background(.primary)
            Text("Erloschen:  \(fileViewModel.getClosedFilesCount(fileFamily: family))")
            Divider().background(.primary)
            TextField("Notiz", text: $text, onCommit: { textViewModel.addNote(family, text) })
                .onChange(of: text) { _ in
                        textViewModel.addNote(family, text)
                }
                .submitLabel(.done)
        }.padding(.vertical)
    }
    
    init( _ familyF: FileFamily, _ text: String) {
        family = familyF
        if let files = familyF.associatedFiles.allObjects as? [File] {
            let fileOfFamily: File = files.filter({$0.id.contains(familyF.id)}).first!
            self.clientSym = fileOfFamily.clientSymbol
        } else {
            self.clientSym = ""
        }
        self.text = text
    }
}

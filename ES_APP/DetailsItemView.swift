
import SwiftUI

struct DetailsItemView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    var file: File
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(file.id).font(Font.system(size: 16))
                    .strikethrough(file.caseStatus.contains("geschlossen") || file.caseStatus.contains("Vernichtet"))
                    .fontWeight(.semibold)
                    .foregroundColor(file.caseStatus.contains("geschlossen") || file.caseStatus.contains("Vernichtet")
                                     ? Color.secondary: Color("HighlightText"))
                Spacer()
                Text(fileViewModel.flagForOneCountry(country: file.country))
            }
            HStack {
                //AKTEMAZERTREG not empty
                if !file.issueNb.isEmpty && file.issueNb != " " {
                    Text("\(file.issueNb)")
                } else if !file.publishNb.isEmpty && file.publishNb != " " {
                    Text("\(file.publishNb)")
                } else if !file.registrationNb.isEmpty && file.registrationNb != " " {
                    Text("\(file.registrationNb)")
                }
                Spacer()
                if file.caseStatus.contains("geschlossen") || file.caseStatus.contains("Vernichtet") {
                    Text("erloschen")
                } else if file.currentState.contains("angelegt") && file.caseStatus.contains("in Bearbeitung") {
                    Text("in Planung")
                } else {
                    Text("\(file.currentState)")
                }
            }
        }.foregroundColor(file.caseStatus.contains("geschlossen") || file.caseStatus.contains("Vernichtet")
                          ? Color.secondary : Color.primary)
    }
    init (_ file: File) {
        self.file = file
    }
}

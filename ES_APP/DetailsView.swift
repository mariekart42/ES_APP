
import SwiftUI

struct DetailsView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    @EnvironmentObject private var dataViewModel: DataViewModel
    @EnvironmentObject private var textViewModel: TextViewModel
    var family: FileFamily
    var sortedFiles: [File]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Spacer().frame(height: 3)
                VStack {
                    Text("\(family.title)")
                        .font(Font.system(size: 16))
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("HighlightText"))
                    DetailsList(family, textViewModel.getNote(family))
                        .environmentObject(fileViewModel)
                        .environmentObject(textViewModel)
                    Spacer().frame(height: 30)
                }
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                
                Spacer().frame(height: 20)
                Text("   Einzelakten")
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .font(.footnote)
                VStack {
                    ForEach(sortedFiles, id: \.self) { file in
                        NavigationLink(destination: FileView(file, true)
                            .environmentObject(fileViewModel)
                            .environmentObject(dataViewModel)) {
                            DetailsItemView(file).environmentObject(fileViewModel)
                        }
                        .padding(15)
                        .background(Color("BoxBackground"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                    }
                    .padding(.vertical, 3)
                }
            }
            .padding(.horizontal, 12)
        }
    }
    
    init(_ familyF: FileFamily) {
        family = familyF
        if let files = family.associatedFiles.allObjects as? [File] {
            sortedFiles = files.sorted { $0.id < $1.id }
        } else {
            sortedFiles = []
        }
    }
}

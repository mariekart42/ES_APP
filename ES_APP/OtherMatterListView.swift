
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


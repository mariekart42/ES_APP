
import SwiftUI

struct FamilyTimelineView: View {
    @StateObject var familyTimelineViewModel = FamilyTimelineViewModel()
    @ObservedObject var family: FileFamily
    
    var body: some View {
        VStack {
            TimelineTable<FamilyTimelineViewModel>(viewModel: familyTimelineViewModel, clickable: false)
                .onAppear {
                    self.familyTimelineViewModel.family = family
                }
        }
    }
    
    init(_ familyF: FileFamily) {
        family = familyF
    }
}

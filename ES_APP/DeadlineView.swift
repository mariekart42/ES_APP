
import SwiftUI

struct DeadlineView: View {
    /// The `DeadlineViewModel` for this view
    @StateObject private var deadlineViewModel = DeadlineViewModel()
    private var resetNavigation: UUID
    @State private var navigationUUId = UUID()
    
    var body: some View {
        NavigationView {
            VStack {
                TimelineTable<DeadlineViewModel>(viewModel: deadlineViewModel, clickable: true)
                NavigationLink("",
                               destination: DeadlineDetailView(deadlineViewModel.showDetailID)
                                                .environmentObject(deadlineViewModel),
                               isActive: $deadlineViewModel.showDetail)
            }
            .searchable(text: $deadlineViewModel.searchString, placement: .navigationBarDrawer(displayMode: .always))
            .disableAutocorrection(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Image("IP_Port_Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 30, alignment: .top)
                        .cornerRadius(25)
                    Text("  Fristen")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(Color("HighlightText"))
                },
                trailing: Button {
                    deadlineViewModel.showFilter = true
                } label: {
                    DeadlineFilterToggle().environmentObject(deadlineViewModel)
                })
            .sheet(isPresented: $deadlineViewModel.showFilter) {
                DeadlineFilterView().environmentObject(deadlineViewModel).accentColor(Color("HighlightText"))
            }
            .onChange(of: resetNavigation) { _ in
                if deadlineViewModel.showDetail == true {
                    deadlineViewModel.changeShowDetails()
                }
                self.navigationUUId = resetNavigation
            }
        }.id(navigationUUId)
    }
    
    init(resetNavigation: UUID) {
        self.resetNavigation = resetNavigation
    }
}

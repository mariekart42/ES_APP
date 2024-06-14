
import SwiftUI

struct PortfolioView: View {
    /// The `FileViewModel` for this view and its subviews
    @StateObject var fileViewModel = FileViewModel ()
    @EnvironmentObject var dataViewModel: DataViewModel
    private var resetNavigation: UUID
    
    var body: some View {
        //swiftlint:disable closure_body_length
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("   Übersicht")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.footnote)
                    VStack {
                        DashboardPieChart(viewModel: fileViewModel)
                            .frame(height: 320)
                    }
                    .padding(15)
                    .background(Color("BoxBackground"))
                    .cornerRadius(10)
                    .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                    
                    Spacer().frame(height: 20)
                    
                    Text("   Schutzrechte")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.footnote)
                    PortfolioViewNavigation()
                        .environmentObject(fileViewModel)
                        .environmentObject(dataViewModel)
                    
                    Spacer().frame(height: 20)
                    
                    Text("   Weitere Akten")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.footnote)
                    PortfolioNavigationCellMT().environmentObject(fileViewModel)
                }
                .padding(.horizontal, 12)
            }
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
                    Text("  IP Portfolio")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(Color("HighlightText"))
                },
                trailing: Button {
                    fileViewModel.showFilter = true
                } label: {
                    FilterToggleWithIndicator().environmentObject(fileViewModel)
                })
                .sheet(isPresented: $fileViewModel.showFilter) {
                    FilterView().environmentObject(fileViewModel).accentColor(Color("HighlightText"))
                }
        }.navigationViewStyle(.stack)
            .id(resetNavigation)
    }

    init(resetNavigation: UUID) {
        self.resetNavigation = resetNavigation
    }
}

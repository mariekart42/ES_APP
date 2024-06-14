
import SwiftUI

struct FilterFamiliesView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    
    var body: some View {
        //swiftlint:disable closure_body_length
        NavigationView {
            ScrollView {
                VStack {
                    DateFilterView().environmentObject(fileViewModel)
                    ProductClassFilterView().environmentObject(fileViewModel)
                    ProductFilterView().environmentObject(fileViewModel)
                    StateFilterView(showClosed: true).environmentObject(fileViewModel)
                    CountryFilterView().environmentObject(fileViewModel)
                    VStack {
                        Button(action: {
                            fileViewModel.showFilter = false
                        }) {
                            Text("Filter anwenden")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .padding(.horizontal, 50)
                                .background(Color("Blue01"))
                                .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            fileViewModel.showFilter = false
                            fileViewModel.filterByDate = false
                            fileViewModel.filterByCountry = false
                            fileViewModel.filterByCurrentState = false
                            fileViewModel.filterByProduct = false
                            fileViewModel.filterByProductClass = false
                        }) {
                            Text("Reset")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .padding(.horizontal, 50)
                                .background(.gray)
                                .clipShape(Capsule())
                        }
                    }.padding(40)
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Text("  Filter")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(Color("HighlightText"))
                })
        }
    }
}

struct FilterFamiliesView_Previews: PreviewProvider {
    static var previews: some View {
        FilterFamiliesView()
    }
}

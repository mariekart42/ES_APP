
import SwiftUI

struct FamilyView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var textViewModel: TextViewModel
    @State private var selectedTab: Int = 0
    
    @Environment(\.colorScheme) var colorScheme

    
    var family: FileFamily
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            Spacer().frame( height: 7)
            Picker("", selection: $selectedTab) {
                Text("Details").tag(0)
                Text("Karte").tag(1)
                Text("Historie").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            .frame(width: geo.size.width - 100)
            .padding(.bottom, 7)
            TabView(selection: $selectedTab) {
                DetailsView(family)
                    .tag(0)
                    .environmentObject(fileViewModel)
                    .environmentObject(textViewModel)
                FamilyMapView(family, mode: colorScheme == .dark ? "dark" : "").tag(1)
                FamilyTimelineView(family).tag(2).environmentObject(fileViewModel)
            }.tabViewStyle(.page(indexDisplayMode: .never))
            Spacer()
        }.navigationTitle(family.id.prefix(7))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button {
                if favoritesViewModel.isFavorite(family) {
                    favoritesViewModel.remove(family)
                } else {
                    favoritesViewModel.addFavorite(family)
                }
            } label: {
                favoritesViewModel.isFavorite(family) ? Image(systemName: "star.fill") : Image(systemName: "star")
            })
        }
    }
    
    
    /// - Parameter model: The `Model` with the saved content of the App
    init(_ familyF: FileFamily) {
        family = familyF
    }
}

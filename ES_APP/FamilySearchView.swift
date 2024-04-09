//
//  FamilySearchView.swift
//  My IP Port
//
//  Created by Henri Petuker on 6/11/22.
//
//  This view displays the list of a specific file familiy type. It provides a search bar,
//  access to the family filter sheet and the option to mark families as favorites.

import SwiftUI

struct FamilySearchView: View {
    // The FileViewModel from the environment
    @StateObject private var fileViewModel = FileViewModel()
    @StateObject private var textViewModel = TextViewModel()
    
    // The FavoritesViewModel created for this view
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    
    // String used for filtering the user input
    @State private var searchString = ""
    
    // The File Families passed on from the previous VIew
    var families: [FileFamily]
    // The matter type description for this family type
    var matterTypDes: String = ""
    
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ZStack {
                    VStack {
                        ListView(searchResults: searchResults)
                            .environmentObject(fileViewModel)
                            .environmentObject(favoritesViewModel)
                            .environmentObject(textViewModel)
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading )
                    .listStyle(.inset)
                    if favoritesViewModel.showingAlert {
                        FavoriteSymbol().environmentObject(favoritesViewModel).allowsHitTesting(false)
                    }
                }
                .navigationTitle(matterTypDes)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button {
                    fileViewModel.showFilter = true
                } label: {
                    FilterToggleWithIndicator().environmentObject(fileViewModel)
                })
                .sheet(isPresented: $fileViewModel.showFilter) {
                   FilterFamiliesView().environmentObject(fileViewModel).accentColor(Color("HighlightText"))
                }
                .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .always))
                    .disableAutocorrection(true)
            }
        }
    }
    
    var searchResults: [FileFamily] {
        if searchString.isEmpty {
            return fileViewModel.applyFamilyFilter(families: families)
        } else {
            return fileViewModel.applyFamilyFilter(families: families).filter {
                $0.id.lowercased().contains(searchString.lowercased())
                || $0.title.lowercased().contains(searchString.lowercased())
                || textViewModel.textMatch($0, searchString.lowercased())
            }
        }
    }
    
    // - Parameter families: The FileFamily List passed on from previous View
    init(_ families: [FileFamily], _ matterTypeDescrip: String) {
        self.families = families
        self.matterTypDes = matterTypeDescrip
    }
}

/*
struct FamilySearchView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            FamilySearchView( model.fileFamilies, "").environmentObject(model).environmentObject(FileViewModel(model))
                .preferredColorScheme(colorScheme)
        }
    }
}
*/

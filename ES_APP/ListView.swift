//
//  ListView.swift
//  My IP Port
//
//  Created by Julian Heiß on 31.05.22.
//

import SwiftUI


struct ListView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var textViewModel: TextViewModel
    var searchResults: [FileFamily]
    
    var body: some View {
        List {
            SectionFavorits(searchResults: searchResults).environmentObject(fileViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(textViewModel)
                .listRowSeparator(.hidden)
            Rectangle().listRowSeparator(.hidden).background(.primary).frame(maxHeight: 2)
            SectionGeneral(searchResults: searchResults).environmentObject(fileViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(textViewModel)
                .listRowSeparator(.hidden)
            Rectangle().listRowSeparator(.hidden).background(.primary).frame(maxHeight: 2)
            SectionPlaned(searchResults: searchResults).environmentObject(fileViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(textViewModel)
        }.listRowSeparator(.hidden)
    }
}

struct SectionFavorits: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var textViewModel: TextViewModel
    var searchResults: [FileFamily]
    
    var body: some View {
        Section(header: Text("Favoriten").foregroundColor(.secondary).textCase(.uppercase).font(.footnote)) {
            ForEach(favoritesViewModel.allFamilyFavorites(searchResults), id: \.self) { family in
                NavigationLink(destination: {
                    FamilyView(family).environmentObject(fileViewModel)
                        .environmentObject(favoritesViewModel)
                        .environmentObject(textViewModel)
                },
                               label: { FamilyCell(family)
                        .environmentObject(fileViewModel).environmentObject(favoritesViewModel)
                         .padding(.bottom, 8)
                }).swipeActions(edge: .trailing) {
                    Button { favoritesViewModel.remove(family)
                        favoritesViewModel.addedFavorite = false
                        favoritesViewModel.showingAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            favoritesViewModel.showingAlert = false
                        }
                    } label: {
                        Image(systemName: "star.slash")
                    }.tint(.orange)
                }
            }
        }
    }
}

struct SectionGeneral: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var textViewModel: TextViewModel
    var searchResults: [FileFamily]
    
    var body: some View {
        Section(header: Text("Allgemein").foregroundColor(.secondary).textCase(.uppercase).font(.footnote)) {
            ForEach(favoritesViewModel.notFamilyFavorites(searchResults, isPlanned: false)) { family in
                NavigationLink(destination: {
                    FamilyView(family).environmentObject(fileViewModel)
                        .environmentObject(favoritesViewModel)
                        .environmentObject(textViewModel)
                }, label: { FamilyCell(family)
                        .environmentObject(fileViewModel).environmentObject(favoritesViewModel)
                         .padding(.bottom, 8)
                }).swipeActions(edge: .leading) {
                    Button { favoritesViewModel.addFavorite(family)
                        favoritesViewModel.addedFavorite = true
                        favoritesViewModel.showingAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            favoritesViewModel.showingAlert = false
                        }
                    } label: {
                        Image(systemName: "star")
                    }.tint(.orange)
                }
            }
        }
    }
}

struct SectionPlaned: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var textViewModel: TextViewModel
    var searchResults: [FileFamily]
    
    var body: some View {
        Section(header: Text("Geplant").foregroundColor(.secondary).textCase(.uppercase).font(.footnote)) {
            ForEach(favoritesViewModel.notFamilyFavorites(searchResults, isPlanned: true)) { family in
                NavigationLink(destination: {
                    FamilyView(family).environmentObject(fileViewModel)
                        .environmentObject(favoritesViewModel)
                        .environmentObject(textViewModel)
                }, label: { FamilyCell(family)
                        .environmentObject(fileViewModel).environmentObject(favoritesViewModel)
                         .padding(.bottom, 8)
                }).swipeActions(edge: .leading) {
                    Button { favoritesViewModel.addFavorite(family)
                        favoritesViewModel.addedFavorite = true
                        favoritesViewModel.showingAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            favoritesViewModel.showingAlert = false
                        }
                    } label: {
                        Image(systemName: "star")
                    }.tint(.orange)
                }
            }
        }
    }
}

/*
 struct ListView_Previews: PreviewProvider {
 private static let model: Model = MockModel()
 
 static var previews: some View {
 ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
 ListView(searchResults: model.fileFamilies).environmentObject(FileViewModel(model))
 .environmentObject(FavoritesViewModel())
 .preferredColorScheme(colorScheme)
 }
 }
 }
 */

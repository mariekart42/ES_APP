//
//  PortfolioViewNavigation.swift
//  My IP Port
//
//  Created by Dominik Remo on 05.07.22.
//

import Foundation
import SwiftUI

struct PortfolioViewNavigation: View {
    /// The `FileViewModel` for this view and its subviews
    @EnvironmentObject var fileViewModel: FileViewModel
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        HStack(alignment: .center) {
            NavigationLink(destination: FamilySearchView(fileViewModel.fileFamilyPatent, "Patente")
                .environmentObject(fileViewModel).environmentObject(favoritesViewModel)) {
                    PortfolioNavigationCell(matterType: "Patente",
                                            matterType2: " ",
                                            familyCount: fileViewModel.fileFamilyPatent.count,
                                            iconName: "icons8-patents")
            }
            .padding(3)
            
            NavigationLink(destination: FamilySearchView(fileViewModel.fileFamilyGS, "Gebrauchsmuster")
                .environmentObject(fileViewModel).environmentObject(favoritesViewModel)) {
                    PortfolioNavigationCell(matterType: "Gebrauchs-",
                                            matterType2: "muster",
                                            familyCount: fileViewModel.fileFamilyGS.count,
                                            iconName: "icons8-utility-model")
            }
            .padding(3)
        }
        
        HStack {
            NavigationLink(destination: FamilySearchView(fileViewModel.fileFamilyBrand, "Marken")
                .environmentObject(fileViewModel).environmentObject(favoritesViewModel)) {
                    PortfolioNavigationCell(matterType: "Marken",
                                            matterType2: " ",
                                            familyCount: fileViewModel.fileFamilyBrand.count,
                                            iconName: "icons8-brands")
            }
            .padding(3)
            
            NavigationLink(destination: FamilySearchView(fileViewModel.fileFamilyDesign, "Designs")
                .environmentObject(fileViewModel).environmentObject(favoritesViewModel)) {
                    PortfolioNavigationCell(matterType: "Designs",
                                            matterType2: " ",
                                            familyCount: fileViewModel.fileFamilyDesign.count,
                                            iconName: "icons8-designs")
            }
            .padding(3)
        }
    }
}

struct PortfolioNavigationCell: View {
    private var matterType: String
    private var matterType2: String
    private var familyCount: Int
    private var iconName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 30, alignment: .top)
            Text("\(matterType)")
                .lineLimit(1)
                .font(.title2)
                .foregroundColor(Color("HighlightText"))
            Text("\(matterType2)")
                .lineLimit(1)
                .font(.title2)
                .foregroundColor(Color("HighlightText"))
            if familyCount == 1 {
                Text("\(familyCount) Familie")
                    .foregroundColor(.secondary)
            } else if familyCount == 0 {
                Text("keine Familien")
                    .foregroundColor(.secondary)
            } else {
                Text("\(familyCount) Familien")
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
    }
    
    init(matterType: String, matterType2: String, familyCount: Int, iconName: String) {
        self.matterType = matterType
        self.familyCount = familyCount
        self.iconName = iconName
        self.matterType2 = matterType2
    }
}


struct PortfolioNavigationCellMT: View {
    /// The `FileViewModel` for this view and its subviews
    @EnvironmentObject var fileViewModel: FileViewModel
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        //swiftlint:disable closure_body_length
        HStack {
            NavigationLink(destination: FamilySearchView(fileViewModel.fileFamilyMT, "Sonstige")
                .environmentObject(fileViewModel).environmentObject(favoritesViewModel)) {
                    VStack(alignment: .leading) {
                        Image("icons8-other-matters")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30, alignment: .top)
                        Text("")
                        Text("Sonstige")
                            .lineLimit(1)
                            .font(.title2)
                            .foregroundColor(Color("HighlightText"))
                        Text(" ")
                            .lineLimit(1)
                            .font(.title2)
                            .foregroundColor(Color("HighlightText"))
                        if fileViewModel.fileFamilyMT.count == 1 {
                            Text("\(fileViewModel.fileFamilyMT.count) Eintrag")
                                .foregroundColor(.secondary)
                        } else if fileViewModel.fileFamilyMT.isEmpty {
                            Text("keine Einträge")
                                .foregroundColor(.secondary)
                        } else {
                            Text("\(fileViewModel.fileFamilyMT.count) Einträge")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color("BoxBackground"))
                    .cornerRadius(10)
                    .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
            .padding(3)
            
            NavigationLink(destination: FamilySearchView(fileViewModel.fileFamilies, "Alle Akten")
                .environmentObject(fileViewModel).environmentObject(favoritesViewModel)) {
                    VStack(alignment: .leading) {
                        Image("icons8-all-files")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30, alignment: .top)
                        Text("")
                        Text("Alle Akten")
                            .lineLimit(1)
                            .font(.title2)
                            .foregroundColor(Color("HighlightText"))
                        Text(" ")
                            .lineLimit(1)
                            .font(.title2)
                            .foregroundColor(Color("HighlightText"))
                        if fileViewModel.fileFamilies.count == 1 {
                            Text("\(fileViewModel.fileFamilies.count) Eintrag")
                                .foregroundColor(.secondary)
                        } else if fileViewModel.fileFamilies.isEmpty {
                            Text("keine Einträge")
                                .foregroundColor(.secondary)
                        } else {
                            Text("\(fileViewModel.fileFamilies.count) Einträge")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color("BoxBackground"))
                    .cornerRadius(10)
                    .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
            .padding(3)
        }
    }
}

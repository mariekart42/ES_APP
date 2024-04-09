//
//  FavoriteSymbol.swift
//  My IP Port
//
//  Created by Julian Heiß on 16.06.22.
//

import SwiftUI

struct FavoriteSymbol: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                if favoritesViewModel.addedFavorite {
                    Text("Favorit hinzugefügt").foregroundColor(Color.primary)
                } else {
                    Text("Favorit entfernt").foregroundColor(Color.primary)
                }
            }.frame(width: 170, height: 30)
                .background(RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.secondary))
            Spacer().frame( height: 20)
        }
    }
}

/*
struct FavoriteSymbol_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    static var previews: some View {
        FavoriteSymbol().environmentObject(FileViewModel(model)).environmentObject(FavoritesViewModel())
    }
}
*/

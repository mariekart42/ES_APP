//
//  FavoritesViewModel.swift
//  My IP Port
//
//  Created by Julian Heiß on 13.06.22.
//

import Foundation
import SwiftUI

/// class to store families which are marked as favorites in the user defaults
class FavoritesViewModel: ObservableObject {
    private var favorites: [String]
    let userDefaults: UserDefaults
    
    @Published var addedFavorite = false
    @Published var showingAlert = false
    
    init() {
        userDefaults = UserDefaults.standard
        favorites = userDefaults.object(forKey: "Favorites") as? [String] ?? []
    }
    
    func isFavorite(_ family: FileFamily) -> Bool {
        favorites.contains(family.id)
    }
    
    func allFamilyFavorites(_ families: [FileFamily]) -> [FileFamily] {
        return families.filter { isFavorite($0) }
    }
    
    //Filters the families that are not in the favourites and have the status "in Planung" or not
    func notFamilyFavorites(_ families: [FileFamily], isPlanned: Bool) -> [FileFamily] {
        let nonFavouriteFamilies: [FileFamily] = families.filter { !isFavorite($0) }
        var filteredFamilies: [FileFamily] = []
        nonFavouriteFamilies.forEach { fileFamily in
            if let files: [File] = fileFamily.associatedFiles.allObjects as? [File] {
                files.forEach { file in
                    if file.id.contains(fileFamily.id) {
                        if isPlanned {
                            if !file.caseStatus.contains("geschlossen") && !file.caseStatus.contains("Vernichtet") {
                                if file.currentState.contains("Akte angelegt") {
                                    filteredFamilies.append(fileFamily)
                                }
                            }
                        } else {
                            if !file.currentState.contains("Akte angelegt") {
                                filteredFamilies.append(fileFamily)
                            } else if file.caseStatus.contains("geschlossen")
                                        || file.caseStatus.contains("Vernichtet") {
                            filteredFamilies.append(fileFamily)
                            }
                        }
                    }
                }
            }
        }
        return filteredFamilies
    }
    
    func addFavorite(_ family: FileFamily) {
        objectWillChange.send()
        favorites.append(family.id)
        save()
    }
    
    func remove(_ family: FileFamily) {
        objectWillChange.send()
        if isFavorite(family) {
            favorites.remove(at: favorites.firstIndex(of: family.id)!)
        }
        save()
    }
    
    func save() {
        userDefaults.set(favorites, forKey: "Favorites")
    }
}

//
//  RatingViewModel.swift
//  My IP Port
//
//  Created by Hochstrat, Selina on 07.07.22.
//

import Foundation
import SwiftUI

//viewModel for store star rating in user defaults
class RatingViewModel: ObservableObject {
    private var ratings : [String:Int] = [:]
    let userDefaults: UserDefaults

    init() {
        userDefaults = UserDefaults.standard
        ratings = userDefaults.object(forKey: "Ratings") as? [String : Int] ?? [:]
    }
    
    func isRated(_ file: File) -> Bool {
        ratings.keys.contains(file.id)
    }
    
    func getRating(_ file: File) -> Int {
        if let rating = ratings[file.id] {
           return rating
        } else {
            return 0
        }
    }
    
    func addRating(_ file: File, rating: Int) {
        objectWillChange.send()
        ratings[file.id] = rating
        save()
    }
    
    func remove(_ file: File) {
        objectWillChange.send()
        if isRated(file) {
            ratings[file.id] = nil
        }
        save()
    }
    
    func save() {
        userDefaults.set(ratings, forKey: "Ratings")
    }
}

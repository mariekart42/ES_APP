//
//  StarsView.swift
//  My IP Port
//
//  Created by Hochstrat, Selina on 01.07.22.
//

import SwiftUI

//view for star rating in fileView
struct StarsView: View {
    @StateObject var ratingViewModel = RatingViewModel()
    var file: File
    var maxRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.secondary
    var onColor = Color("HighlightText")

  var body: some View {
    HStack {
        ForEach(1..<maxRating + 1, id: \.self) { number in
            image(rating: ratingViewModel.getRating(file), for: number)
                .font(.system(size: 22))
                .foregroundColor(number > ratingViewModel.getRating(file) ? offColor : onColor)
                .onTapGesture(count: 1) {
                    if ratingViewModel.getRating(file) == number {
                       ratingViewModel.remove(file)
                    } else {
                    ratingViewModel.addRating(file, rating: number)
                    }
                }
        }
    }
  }
    
    func image(rating: Int, for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    init(_ file: File) {
        self.file = file
    }
}

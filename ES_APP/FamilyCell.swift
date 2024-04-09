//
//  FamilyCell.swift
//  My IP Port
//
//  Created by Julian Heiß on 16.06.22.
//

import SwiftUI

struct FamilyCell: View {
    var family: FileFamily
    @EnvironmentObject var fileViewModel: FileViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    private var clientSym: String
    
    
    var body: some View {
        //swiftlint:disable closure_body_length
        VStack {
            HStack {
                Text(family.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundColor(Color("HighlightText"))
                    .padding(.bottom, 3)
                Spacer()
            }
            
            HStack {
                HStack(spacing: 7) {
                    Image(systemName: "folder")
                        .resizable()
                        .frame(maxWidth: 15, maxHeight: 13)//, alignment: .top)
                    Text(clientSym.isEmpty ? String(family.id.prefix(7)) : clientSym)
                        .fontWeight(.light)
                        .textCase(.uppercase)
                        .foregroundColor(.primary)
                }
                .frame(height: 20)
                .padding(4)
                .background(Color("SecondBoxBackground"))
                .cornerRadius(5)
                if favoritesViewModel.isFavorite(family) {
                    HStack(spacing: 7) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 15, alignment: .top)
                            .foregroundColor(Color("HighlightText"))
                        Text("Favorit")
                            .fontWeight(.light)
                            .foregroundColor(Color("HighlightText"))
                    }
                    .frame(height: 20)
                    .padding(4)
                    .background(Color("SecondBoxBackground"))
                    .cornerRadius(5)
                }
            }
            .padding(.bottom, 3)
            
            Divider()
            
            HStack {
                // List countries of the patent family
                HStack(spacing: 3) {
                    //Image(systemName: "globe.europe.africa")
                    if let countries = family.countries.allObjects as? [StringCD] {
                        let countryFlagString = fileViewModel.flag(countries: countries)
                        Text(countryFlagString)
                            .font(.footnote)
                            //.frame(width: 130, height: 45, alignment: .leading)
                                .lineLimit(1)
                    } else {
                        Text("")
                    }
                    //.foregroundColor(favoritesViewModel.isFavorite(family) ? .blue : .primary)
                }
                Spacer()
                // Show registration date if set
                HStack(spacing: 3) {
                    Image(systemName: "calendar")
                    if family.registrationDate.timeIntervalSinceReferenceDate != 0 {
                        Text(fileViewModel.getDate(date: family.registrationDate))
                    } else {
                        Text("-")
                    }
                }
            }.padding(.top, 4)
        }
        .padding(22)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(favoritesViewModel.isFavorite(family) ? UIColor.init(Color("HighlightText")) : UIColor.init(.clear)), lineWidth: 4))
        
    }
    
    /*
    var body: some View {
        VStack {
            HStack{
                Text(family.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.bottom, 3)
                Spacer()
            }
            //.foregroundColor(favoritesViewModel.isFavorite(family) ? .orange : .primary)
            HStack(spacing: 7) {
                Image(systemName: "folder")
                Text(clientSym.isEmpty ? String(family.id.prefix(7)) : clientSym)
                    .italic()
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
            }
            Divider()
            
            HStack {
                // List countries of the patent family
                HStack(spacing: 3) {
                    //Image(systemName: "globe.europe.africa")
                    if let countries = family.countries.allObjects as? [StringCD] {
                        let countryFlagString = fileViewModel.flag(countries: countries)
                        Text(countryFlagString)
                            .font(.footnote)
                            //.frame(width: 130, height: 45, alignment: .leading)
                                .lineLimit(1)
                    } else {
                        Text("")
                    }
                    //.foregroundColor(favoritesViewModel.isFavorite(family) ? .blue : .primary)
                }
                Spacer()
                // Show registration date if set
                HStack(spacing: 3) {
                    Image(systemName: "calendar")
                    if family.registrationDate.timeIntervalSinceReferenceDate != 0 {
                        Text(fileViewModel.getDate(date: family.registrationDate))
                    } else {
                        Text("-")
                    }
                }
            }.padding(.top, 4)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 16)
        .stroke(Color(favoritesViewModel.isFavorite(family) ? UIColor.systemOrange : UIColor.systemGray6), lineWidth: 4))
        .background(RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color(UIColor.systemBackground))
            .shadow(color: Color.primary.opacity(0.25), radius: 6, x: 6, y: 6)
        )
        // .padding(.horizontal, 15)
    }
    */
    init(_ familyF: FileFamily) {
        family = familyF
        if let files = familyF.associatedFiles.allObjects as? [File] {
            if let fileOfFamily = files.filter({$0.id.contains(familyF.id)}).first {
                self.clientSym = fileOfFamily.clientSymbol
            } else {
                self.clientSym = ""
            }
        } else {
        self.clientSym = ""
        }
    }
}

/*
struct FamilyCell_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            FamilyCell(model.fileFamilies.first!)
                .environmentObject(FileViewModel(model)).environmentObject(FavoritesViewModel())
                .preferredColorScheme(colorScheme)
        }
    }
}
*/

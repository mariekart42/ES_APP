
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

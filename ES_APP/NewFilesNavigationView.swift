//
//  NewFilesNavigationView.swift
//  My IP Port
//
//  Created by Johannes Fuest on 10.07.22.
//

import Foundation
import SwiftUI

struct NewFilesNavigationView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    @EnvironmentObject var dataViewModel: DataViewModel
    var laggedDate: Date
    
    var body: some View {
        //swiftlint:disable closure_body_length
        VStack(alignment: .leading) {
        HStack {
            let newFilesCount = fileViewModel.getAllNewFiles(date: laggedDate, filetype: .patent).count
            if newFilesCount == 0 {
                HStack {
                    Text("Patente")
                    Spacer()
                    Text("\(newFilesCount)")
                }
                .frame(height: 30)
                .foregroundColor(.secondary)
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            } else {
                NavigationLink(destination: NewPatentsView(newPatents: fileViewModel.getAllNewFiles(date: laggedDate, filetype: .patent))
                    .environmentObject(fileViewModel).environmentObject(dataViewModel)) {
                    HStack {
                        Text("Patente")
                        Spacer()
                        Text("\(newFilesCount)")
                    }
                }
                .frame(height: 30)
                .foregroundColor(Color("HighlightText"))
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
            
            let newGSCount = fileViewModel.getAllNewFiles(date: laggedDate, filetype: .gebrauchsmuster).count
            if newGSCount == 0 {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Gebrauchs-")
                        Text("muster")
                    }
                    Spacer()
                    Text("\(newGSCount)")
                }
                .frame(height: 30)
                .foregroundColor(.secondary)
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            } else {
                NavigationLink(destination: NewGebrauchsmusterView(newGebrauchsmuster:
                fileViewModel.getAllNewFiles(date: laggedDate, filetype: .gebrauchsmuster))
                .environmentObject(fileViewModel)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Gebrauchs-")
                            Text("muster")
                        }
                        Spacer()
                        Text("\(newGSCount)")
                    }
                }
                .frame(height: 30)
                .foregroundColor(Color("HighlightText"))
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
        }
        HStack {
            let newBrandCount = fileViewModel.getAllNewFiles(date: laggedDate, filetype: .brand).count
            if newBrandCount == 0 {
                HStack {
                    Text("Marken")
                    Spacer()
                    Text("\(newBrandCount)")
                }
                .frame(height: 30)
                .foregroundColor(.secondary)
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            } else {
                NavigationLink(destination: NewMarkenView(newBrands: fileViewModel.getAllNewFiles(date: laggedDate, filetype: .brand))
                .environmentObject(fileViewModel)) {
                    HStack {
                        Text("Marken")
                        Spacer()
                        Text("\(newBrandCount)")
                    }
                }
                .frame(height: 30)
                .foregroundColor(Color("HighlightText"))
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
            let newDesignCount = fileViewModel.getAllNewFiles(date: laggedDate, filetype: .design).count
            if newDesignCount == 0 {
                HStack {
                    Text("Designs")
                    Spacer()
                    Text("\(newDesignCount)")
                }
                .foregroundColor(.secondary)
                .frame(height: 30)
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            } else {
                NavigationLink(destination: NewDesignsView(newDesigns: fileViewModel.getAllNewFiles(date: laggedDate, filetype: .design))
                .environmentObject(fileViewModel)) {
                    HStack {
                        Text("Designs")
                        Spacer()
                        Text("\(newDesignCount)")
                    }
                }
                .frame(height: 30)
                .foregroundColor(Color("HighlightText"))
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
        }
        HStack {
            let newOtherCount = fileViewModel.getAllNewFiles(date: laggedDate, filetype: .other).count
            if newOtherCount == 0 {
                HStack {
                    Text("Sonstige")
                    Spacer()
                    Text("\(newOtherCount)")
                }
                .foregroundColor(.secondary)
                .frame(height: 30)
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            } else {
                NavigationLink(destination: NewSonstigeView(newSonstige: fileViewModel.getAllNewFiles(date: laggedDate, filetype: .other))
                    .environmentObject(fileViewModel)) {
                    HStack {
                        Text("Sonstige")
                        Spacer()
                        Text("\(newOtherCount)")
                    }
                }
                .frame(height: 30)
                .foregroundColor(Color("HighlightText"))
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
            HStack {
                Text(" ")
                Spacer()
                Text(" ")
            }
            .frame(height: 30)
            .padding(15)
            .cornerRadius(10)
        }
        }
    }

    init(date: Date) {
        laggedDate = date
    }
}


struct NewFilesNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NewFilesNavigationView(date: Date())
                .preferredColorScheme(colorScheme)
        }
    }
}

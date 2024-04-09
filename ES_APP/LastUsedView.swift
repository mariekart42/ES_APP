//
//  LastUsedView.swift
//  My IP Port
//
//  Created by Johannes Fuest on 10.07.22.
//

import Foundation
import SwiftUI

struct LastUsedView: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @EnvironmentObject var fileViewModel: FileViewModel
    var body: some View {
        VStack {
            LastUsedFile().environmentObject(dataViewModel).environmentObject(fileViewModel)
                if let secondLastViewedFile =
                    dataViewModel.userDefaults.object(forKey: "secondLastUsedFile") as? String {
                    NavigationLink(destination: FileView(fileViewModel.getFileByID(id: secondLastViewedFile)!, false)
                        .environmentObject(fileViewModel)) {
                        DetailsItemView(fileViewModel.getFileByID(id: secondLastViewedFile)!)
                                .environmentObject(fileViewModel)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color("BoxBackground"))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                    }
                }
                if let thirdLastViewedFile =
                    dataViewModel.userDefaults.object(forKey: "thirdLastUsedFile") as? String {
                    NavigationLink(destination: FileView(fileViewModel.getFileByID(id: thirdLastViewedFile)!, false)
                        .environmentObject(fileViewModel)) {
                        DetailsItemView(fileViewModel.getFileByID(id: thirdLastViewedFile)!)
                                .environmentObject(fileViewModel)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color("BoxBackground"))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                    }
                }
        }
    }
}

struct LastUsedView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            LastUsedView()
                .preferredColorScheme(colorScheme)
        }
    }
}

struct LastUsedFile: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @EnvironmentObject var fileViewModel: FileViewModel
    var body: some View {
        Group {
            if let lastViewedFile = dataViewModel.userDefaults.object(forKey: "lastUsedFile") as? String,
               let fileByID = fileViewModel.getFileByID(id: lastViewedFile) {
                NavigationLink(destination: FileView(fileByID, false)
                    .environmentObject(fileViewModel)) {
                        DetailsItemView(fileByID)
                            .environmentObject(fileViewModel)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color("BoxBackground"))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                    }
            } else {
                HStack {
                    Text("No recently used Patent detected.")
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            }
        }
    }
}

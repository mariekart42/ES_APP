//
//  DashboardView.swift
//  My IP Port
//
//  Created by Julian Heiß on 31.05.22.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @StateObject var deadLineViewModel = DeadlineViewModel()
    /// The `FileViewModel` for this view and its subviews, gives access to all files
    @StateObject var fileViewModel = FileViewModel()
    private var resetNavigation: UUID
    var body: some View {
        //swiftlint:disable closure_body_length
        NavigationView {
            ScrollView {
                Spacer().frame(height: 10)
                VStack(alignment: .leading, spacing: 10) {
                    VStack {
                        Spacer()
                        HStack(alignment: .center) {
                            if let logoData = dataViewModel.userDefaults.object(forKey: "userLogo") as? [UInt8] {
                                if let image = fileViewModel.getCustomerLogo(data: logoData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(10)
                                        .frame(minWidth: 50, maxWidth: 100, minHeight: 50, maxHeight: 100, alignment: .center)
                                        .padding(.horizontal, 10)
                                        .padding(.bottom, 5)
                                }
                            }
                            Image("ES_Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 100, maxHeight: 37, alignment: .center)
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 5)
                        }
                        Spacer()
                        if let lastUpdateDate = dataViewModel.userDefaults.object(forKey: "lastUpdateDate") as? Date {
                            Text("Zuletzt aktualisiert: \(lastUpdateDate.formatted(.dateTime))").foregroundColor(.secondary)
                        } else {
                            Text("Keine Daten abgerufen")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .padding(15)
                    .background(Color("BoxBackground"))
                    .cornerRadius(10)
                    .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                    .padding(.top, 10)
                    
                    Spacer().frame(height: 30)
                    Text("   Neu hinzugekommene Akten")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.footnote)
                    if let lastUpdateDateLagged =
                        dataViewModel.userDefaults.object(forKey: "lastUpdateDateLagged") as? Date {
                        NewFilesNavigationView(date: lastUpdateDateLagged).environmentObject(fileViewModel)
                            .environmentObject(dataViewModel)
                    } else {
                        NewFilesNavigationView(date: Date(timeIntervalSinceReferenceDate: -785010402.0))
                            .environmentObject(fileViewModel)
                    }

                    Spacer().frame(height: 30)
                    Text("   Anstehende Fristen")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.footnote)
                    NextDeadlinesNavigationView().environmentObject(deadLineViewModel)
                    
                    Spacer().frame(height: 30)
                    Text("   Zuletzt verwendet")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.footnote)
                    LastUsedView().environmentObject(dataViewModel).environmentObject(fileViewModel)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 12)
                .foregroundColor(.primary)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                }
            }.id(resetNavigation)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: HStack {
                        Image("IP_Port_Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30, alignment: .top)
                            .cornerRadius(25)
                        Text("  Home")
                            .font(.title)
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color("HighlightText"))
                    })
        }
            
    }
    
    init(resetNavigation: UUID) {
        self.resetNavigation = resetNavigation
    }
}

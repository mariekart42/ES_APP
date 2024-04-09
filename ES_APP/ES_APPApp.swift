//
//  ES_APPApp.swift
//  ES_APP
//
//  Created by Marie Mensing on 04.01.24.
//

import SwiftUI

@main
//swiftlint:disable:next type_name
struct My_IP_PortApp: App {
    /// //The View Model that checks if App was unlocked
    @StateObject var lockedViewModel = LockedViewModel()
    /// The `Model` used within the App
    @StateObject var authentication = Authentication()
    // The shared Core Data Controller managing the persistent data
    let persistenceController = PersistenceController.shared
    
    // The View Model that modifies the persistent data
    @StateObject var dataViewModel = DataViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authentication.isUnlocked {
                if let loginStatus = dataViewModel
                    .userDefaults
                    .object(forKey: "loginStatus") as? Bool {
                    if loginStatus == true {
                        ContentView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .environmentObject(dataViewModel)
                            .environmentObject(authentication)
                    } else {
                        LoginView()
                            .environmentObject(authentication)
                            .accentColor(Color("HighlightText"))
                    }
                } else {
                    LoginView()
                        .environmentObject(authentication)
                        .accentColor(Color("HighlightText"))
                }
            } else {
                if authentication.biometricType() == .none {
                    LoginView()
                        .environmentObject(authentication)
                        .accentColor(Color("HighlightText"))
                } else {
                    LockedView().environmentObject(lockedViewModel)
                        .environmentObject(authentication)
                        .accentColor(Color("HighlightText"))
                }
            }
        }
    }
}

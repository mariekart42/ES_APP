//
//  ContentView.swift
//  ES_APP
//
//  Created by Marie Mensing on 04.01.24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State var didLoad = false
    @State var ifLoggedIn = false
    @State private var resetNavigationHome = UUID()
    @State private var resetNavigationPortfolio = UUID()
    @State private var resetNavigationTimeline = UUID()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        if didLoad {
            let selectable = Binding(get: { selectedTab }, set: {
                if $0 == selectedTab {
                    if selectedTab == 0 {
                        resetNavigationHome = UUID()
                    } else if selectedTab == 1 {
                        resetNavigationPortfolio = UUID()
                    } else if selectedTab == 2 {
                        resetNavigationTimeline = UUID()
                    }
                }
                selectedTab = $0
                })
            TabView(selection: selectable) {
                DashboardView(resetNavigation: resetNavigationHome).tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
                PortfolioView(resetNavigation: resetNavigationPortfolio).tabItem {
                    Image(systemName: "folder")
                    Text("Portfolio")
                }
                .tag(1)
                DeadlineView(resetNavigation: resetNavigationTimeline).tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Fristen")
                }
                .tag(2)
                SettingView()
                    .tabItem {
                    Image(systemName: "gear")
                    Text("Einstellungen")
                    }
                .tag(3)
            }
            .accentColor(Color("HighlightText"))
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                didLoad = false
            }
        } else {
            LoadingView(didLoad: $didLoad).task {
                selectedTab = 0
            }
        }
    }
    
    init() {
        // Change styling of all NavigationBar titles
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 20)!,
                          NSAttributedString.Key.foregroundColor: UIColor.init(Color("HighlightText"))]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
}


//
//  TabsView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 05/05/25.
//

import SwiftUI


struct TabsView: View {
    // Enumerating tabs keeps the selection strongly-typed.
    private enum Tab {
        case home, settings
    }

    @State private var selection: Tab = .home

    var body: some View {
        TabView(selection: $selection) {

            HomeView()
                .tag(Tab.home)
                .tabItem {
                    Label("Home",
                          systemImage: selection == .home ? "house.fill" : "house")
                }


            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    Label("Settings",
                          systemImage: selection == .settings ? "gearshape.fill" : "gearshape")
                }
        }
        .tint(Color(hex: "#A5DEFE"))
    }
}


#Preview {
    TabsView()
}

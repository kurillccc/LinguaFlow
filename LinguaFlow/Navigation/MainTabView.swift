//
//  MainTabView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Tab = .home
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"
 
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label(Tab.home.title, systemImage: Tab.home.icon) }
                .tag(Tab.home)
                .toolbarBackground(.visible, for: .tabBar)

            LevelsTabView()
                .tabItem { Label(Tab.lessons.title, systemImage: Tab.lessons.icon) }
                .tag(Tab.lessons)
                .toolbarBackground(.visible, for: .tabBar)
 
            FlashcardsView()
                .tabItem {
                    Label(Tab.practice.title, systemImage: Tab.practice.icon)
                }
                .tag(Tab.practice)
                .toolbarBackground(.visible, for: .tabBar)

//            ProgressView()
//                .tabItem {
//                    Label(Tab.progress.title, systemImage: Tab.progress.icon)
//                }
//                .tag(Tab.progress)
            

        }
        .tint(selectedTab.color)
        .preferredColorScheme(
            selectedTheme == "light" ? .light :
            selectedTheme == "dark" ? .dark : nil
        )
    }
    
}

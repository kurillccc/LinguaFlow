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
                .tabItem {
                    Label(Tab.home.title, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)
 
            LevelsTabView()
                .tabItem {
                    Label(Tab.lessons.title, systemImage: Tab.lessons.icon)
                }
                .tag(Tab.lessons)
 
//            PracticeView()
//                .tabItem {
//                    Label(Tab.practice.title, systemImage: Tab.practice.icon)
//                }
//                .tag(Tab.practice)
// 
//            ProgressView()
//                .tabItem {
//                    Label(Tab.progress.title, systemImage: Tab.progress.icon)
//                }
//                .tag(Tab.progress)
            
            SettingsView()
                .tabItem {
                    Label(Tab.settings.title, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
        .tint(selectedTab.color)
        .preferredColorScheme(
            selectedTheme == "light" ? .light :
            selectedTheme == "dark" ? .dark : nil
        )
    }
    
}

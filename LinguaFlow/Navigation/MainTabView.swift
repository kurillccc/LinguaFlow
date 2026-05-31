//
//  MainTabView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import Foundation
import SwiftUI
 
// MARK: - Tab enum
 
enum Tab: Int, CaseIterable {
    
    case home, lessons, practice, progress, settings

    var title: String {
        switch self {
        case .home:
            return "Главная"
        case .lessons:
            return "Уроки"
        case .practice:
            return "Практика"
        case .progress:
            return "Прогресс"
        case .settings:
            return "Настройки"
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .lessons:  
            return "headphones"
        case .practice:
            return "rectangle.stack.fill"
        case .progress:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }

    var color: Color {
        switch self {
        case .home:
            return Color(red: 0.27, green: 0.73, blue: 0.56)

        case .lessons:
            return Color(red: 0.25, green: 0.56, blue: 0.87)

        case .practice:
            return Color(red: 0.95, green: 0.55, blue: 0.25)

        case .progress:
            return Color(red: 0.72, green: 0.37, blue: 0.95)

        case .settings:
            return Color(red: 0.45, green: 0.48, blue: 0.55)
        }
    }
    
}
 
// MARK: - MainTabView
 
struct MainTabView: View {
    
    @State private var selectedTab: Tab = .home
 
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
    }
    
}

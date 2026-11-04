//
//  Tab.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.06.2026.
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case home, achievements, lessons, practice, progress, settings

    var title: String {
        switch self {
        case .home: return "Главная"
        case .achievements: return "Достижения"
        case .lessons: return "Уроки"
        case .practice: return "Практика"
        case .progress: return "Прогресс"
        case .settings: return "Настройки"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .achievements: return "trophy.fill"
        case .lessons: return "headphones"
        case .practice: return "rectangle.stack.fill"
        case .progress: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }

    var color: Color {
        switch self {
        case .achievements: return Color(red: 0.27, green: 0.65, blue: 0.49)
        case .home: return Color(red: 0.27, green: 0.73, blue: 0.56)
        case .lessons: return Color(red: 0.25, green: 0.56, blue: 0.87)
        case .practice: return Color(red: 0.95, green: 0.55, blue: 0.25)
        case .progress: return Color(red: 0.72, green: 0.37, blue: 0.95)
        case .settings: return Color(red: 0.45, green: 0.48, blue: 0.55)
        }
    }
}

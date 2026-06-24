//
//  LevelsLoader+extension.swift
//  LinguaFlow
//
//  Created by Кирилл on 23.06.2026.
//

import Foundation
import SwiftUI

extension LevelLoader {
    
    static func subtitle(for level: Int) -> String {
        switch level {
        case 1: return "А1"
        case 2: return "А2"
        case 3: return "B1"
        default: return "Unknown"
        }
    }
    
    static func description(for level: Int) -> String {
        switch level {
        case 1: return "Постановка произношения и преодоление языкового барьера"
        case 2: return "Развитие беглости речи и построение более длинных фраз"
        case 3: return "Свободное бытовое общение без подсказок на русском языке"
        default: return ""
        }
    }
    
    static func icon(for level: Int) -> String {
        switch level {
        case 1: return "🌱"
        case 2: return "🔥"
        case 3: return "⚡️"
        default: return "📘"
        }
    }
}

extension LevelLoader {
    
    static func color(for level: Int) -> Color {
        switch level {
        case 1:
            return Color(red: 0.27, green: 0.73, blue: 0.56)
        case 2:
            return Color(red: 0.25, green: 0.56, blue: 0.87)
        case 3:
            return Color(red: 0.72, green: 0.37, blue: 0.95)
        default:
            return .gray
        }
    }
}

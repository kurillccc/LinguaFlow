//
//  LevelsLoader.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import Foundation
import SwiftUI

final class LevelLoader {
    
    static func load(level id: Int) -> Level? {
        
        guard let url = Bundle.main.url(forResource: "level\(id)", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let dto = try? JSONDecoder().decode(LevelDTO.self, from: data)
        else {
            return nil
        }
        
        let lessons = dto.lessons.enumerated().map { index, lessonDTO in
            Lesson(
                id: lessonDTO.id,
                levelId: dto.level,
                title: lessonDTO.title,
                duration: lessonDTO.duration,
                isCompleted: index < 2,
                isLocked: index > 5,
                audioFile: String(lessonDTO.id),
                text: lessonDTO.text
            )
        }
        
        return Level(
            id: dto.level,
            title: "Level \(dto.level)",
            subtitle: subtitle(for: dto.level),
            description: description(for: dto.level),
            color: color(for: dto.level),
            icon: icon(for: dto.level),
            lessons: lessons
        )
    }
    
}

private extension LevelLoader {
    
    static func subtitle(for level: Int) -> String {
        switch level {
        case 1: return "Beginner"
        case 2: return "Intermediate"
        case 3: return "Advanced"
        default: return "Unknown"
        }
    }
    
    static func description(for level: Int) -> String {
        switch level {
        case 1: return "Основы языка, базовые фразы и приветствия"
        case 2: return "Разговорные темы, грамматика и диалоги"
        case 3: return "Сложные конструкции, акцент и беглость речи"
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

private extension LevelLoader {
    
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

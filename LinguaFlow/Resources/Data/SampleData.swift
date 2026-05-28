//
//  SampleData.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import Foundation
import SwiftUI

extension Level {
    
    static let all: [Level] = [
        Level(
            id: 1,
            title: "Level 1",
            subtitle: "Beginner",
            description: "Основы языка, базовые фразы и приветствия",
            color: Color(red: 0.27, green: 0.73, blue: 0.56),
            icon: "🌱",
            lessonsCount: 30
        ),
        Level(
            id: 2,
            title: "Level 2",
            subtitle: "Intermediate",
            description: "Разговорные темы, грамматика и диалоги",
            color: Color(red: 0.25, green: 0.56, blue: 0.87),
            icon: "🔥",
            lessonsCount: 30
        ),
        Level(
            id: 3,
            title: "Level 3",
            subtitle: "Advanced",
            description: "Сложные конструкции, акцент и беглость речи",
            color: Color(red: 0.72, green: 0.37, blue: 0.95),
            icon: "⚡️",
            lessonsCount: 30
        )
    ]
    
}
 
extension Lesson {
    
    static func forLevel(_ levelId: Int) -> [Lesson] {
        let topics: [[String]] = [
            // Level 1
            ["Приветствия и знакомство", "Числа и счёт", "Цвета и формы",
             "Дни недели", "Еда и напитки", "Семья и родственники",
             "Дом и комнаты", "Транспорт", "Погода", "Прощание"],
            
            // Level 2
            ["В кафе и ресторане", "Шоппинг и покупки", "Путешествия",
             "Работа и профессии", "Здоровье и тело", "Хобби и досуг",
             "Город и ориентация", "Прошедшее время", "Будущее время", "Условные предложения"],
            
            // Level 3
            ["Идиомы и фразеологизмы", "Деловой язык", "Новости и медиа",
             "Философия и мнения", "Искусство и культура", "Наука и технологии",
             "Политика и общество", "Юмор и сленг", "Сложный акцент", "Финальный тест"]
        ]
 
        let durations = ["4:30", "5:15", "3:50", "6:20", "4:45", "5:00", "4:10", "5:30", "4:55", "6:00"]
 
        return topics[levelId - 1].enumerated().map { index, title in
            let globalIndex = (levelId - 1) * 10 + index
            return Lesson(
                id: globalIndex + 1,
                levelId: levelId,
                title: title,
                duration: durations[index],
                isCompleted: index < 2,
                isLocked: levelId > 1 && index > 5
            )
        }
    }
    
}

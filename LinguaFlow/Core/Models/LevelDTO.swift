//
//  LevelDTO.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

struct LevelDTO: Codable {
    let level: Int
    let lessons: [LessonDTO]
}

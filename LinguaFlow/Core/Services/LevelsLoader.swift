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
                audioFile: String(lessonDTO.id),
                text: lessonDTO.text
            )
        }
        
        return Level(
            id: dto.level,
            title: "Уровень \(dto.level)",
            subtitle: subtitle(for: dto.level),
            description: description(for: dto.level),
            color: color(for: dto.level),
            icon: icon(for: dto.level),
            lessons: lessons
        )
    }
    
}

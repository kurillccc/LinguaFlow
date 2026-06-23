//
//  LessonProgress+Mapper.swift
//  LinguaFlow
//
//  Created by Кирилл on 09.06.2026.
//

import Foundation

extension LessonProgressEntity {

    func toModel() -> LessonProgress {
        LessonProgress(
            lessonId: Int(lessonId),
            levelId: Int(levelId),
            isCompleted: isCompleted,
            lastPosition: lastPosition
        )
    }
    
}

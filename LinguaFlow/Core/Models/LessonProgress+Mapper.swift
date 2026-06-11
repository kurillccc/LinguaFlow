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
            isCompleted: isCompleted,
            lastPosition: lastPosition
        )
    }
    
}

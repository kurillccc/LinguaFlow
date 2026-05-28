//
//  Lesson.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import Foundation

struct Lesson: Identifiable {
    let id: Int
    let levelId: Int
    let title: String
    let duration: String
    let isCompleted: Bool
    let isLocked: Bool
}

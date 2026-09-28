//
//  Flashcard.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.09.2026.
//

import Foundation

struct Flashcard: Identifiable, Hashable {
    let id: UUID
    let word: String
    let translation: String
    let example: String?
    let createdAt: Date
    let box: Int
    let lastReviewedAt: Date?

    /// Карточка считается выученной, когда достигнута финальная "коробка" интервального повторения.
    static let masteredBox = 3

    var isLearned: Bool { box >= Flashcard.masteredBox }
}

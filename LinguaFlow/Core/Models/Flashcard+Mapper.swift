//
//  Flashcard+Mapper.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.09.2026.
//

import Foundation

extension FlashcardEntity {

    func toModel() -> Flashcard {
        Flashcard(
            id: id ?? UUID(),
            word: word ?? "",
            translation: translation ?? "",
            example: (example?.isEmpty ?? true) ? nil : example,
            createdAt: createdAt ?? Date(),
            box: Int(box),
            lastReviewedAt: lastReviewedAt
        )
    }

}

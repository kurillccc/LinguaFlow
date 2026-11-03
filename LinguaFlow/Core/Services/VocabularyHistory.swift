//
//  VocabularyHistory.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import Foundation
import Combine

/// Historical counters survive deleting a card or forgetting a previously mastered word.
final class VocabularyHistory: ObservableObject {
    static let shared = VocabularyHistory()
    @Published private(set) var revision = 0
    private let defaults: UserDefaults
    private(set) var addedWords: Set<String>
    private(set) var masteredCardIDs: Set<String>

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        addedWords = Set(defaults.stringArray(forKey: "achievements.addedWords") ?? [])
        masteredCardIDs = Set(defaults.stringArray(forKey: "achievements.masteredCards") ?? [])
    }

    static func normalized(_ word: String) -> String {
        word.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
            .precomposedStringWithCanonicalMapping.lowercased(with: Locale(identifier: "en_US_POSIX"))
    }

    func record(word: String, masteredID: UUID? = nil) {
        let before = addedWords.count + masteredCardIDs.count
        let key = Self.normalized(word)
        if !key.isEmpty { addedWords.insert(key) }
        if let masteredID { masteredCardIDs.insert(masteredID.uuidString) }
        if addedWords.count + masteredCardIDs.count != before { persist() }
    }

    func seed(from cards: [Flashcard]) {
        let before = addedWords.count + masteredCardIDs.count
        for card in cards {
            let key = Self.normalized(card.word)
            if !key.isEmpty { addedWords.insert(key) }
            if card.isLearned { masteredCardIDs.insert(card.id.uuidString) }
        }
        if addedWords.count + masteredCardIDs.count != before { persist() }
    }

    private func persist() {
        defaults.set(Array(addedWords), forKey: "achievements.addedWords")
        defaults.set(Array(masteredCardIDs), forKey: "achievements.masteredCards")
        revision += 1
    }
}

//
//  FavoriteLessonsStore.swift
//  LinguaFlow
//
//  Created by Кирилл on 11.11.2026.
//

import Foundation
import Combine

final class FavoriteLessonsStore: ObservableObject {
    static let shared = FavoriteLessonsStore()

    @Published private(set) var lessonKeys: Set<String>

    private let defaults = UserDefaults.standard
    private let storageKey = "favoriteLessonKeys"

    private init() {
        lessonKeys = Set(defaults.stringArray(forKey: storageKey) ?? [])
    }

    func isFavorite(_ lesson: Lesson) -> Bool {
        lessonKeys.contains(key(for: lesson))
    }

    func toggle(_ lesson: Lesson) {
        let lessonKey = key(for: lesson)
        if lessonKeys.contains(lessonKey) {
            lessonKeys.remove(lessonKey)
        } else {
            lessonKeys.insert(lessonKey)
        }
        defaults.set(lessonKeys.sorted(), forKey: storageKey)
    }

    private func key(for lesson: Lesson) -> String {
        "\(lesson.levelId)_\(lesson.id)"
    }
}

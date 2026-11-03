//
//  AchievementStore.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import Foundation
import Combine

final class AchievementStore: ObservableObject {
    static let shared = AchievementStore()
    @Published private(set) var achievements: [AchievementState] = []
    @Published private(set) var pendingIDs: [String]
    var activeLessonIDs = Set<UUID>()
    private var ledger: AchievementLedger
    private var subscriptions = Set<AnyCancellable>()
    private let levels = (1...3).compactMap { LevelLoader.load(level: $0) }

    init(defaults: UserDefaults = .standard) {
        let ledger = AchievementLedger(defaults: defaults)
        self.ledger = ledger
        pendingIDs = ledger.pendingIDs

        Publishers.CombineLatest4(
            ProgressManager.shared.$progressCache,
            FlashcardStore.shared.$cards,
            ReviewHistory.shared.$days,
            VocabularyHistory.shared.$revision
        )
        .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
        .sink { [weak self] _ in self?.refresh() }
        .store(in: &subscriptions)
    }

    var earnedCount: Int { achievements.filter(\.isEarned).count }
    var nextAchievements: [AchievementState] {
        Array(achievements.filter { !$0.isEarned }.sorted {
            if $0.fraction != $1.fraction { return $0.fraction > $1.fraction }
            return $0.target < $1.target
        }.prefix(3))
    }

    func refresh() {
        var snapshot = AchievementSnapshot()
        for level in levels {
            snapshot.lessonTotals[level.id] = level.lessons.count
            snapshot.completedLessons[level.id] = level.lessons.filter {
                ProgressManager.shared.load(levelId: level.id, lessonId: $0.id)?.isCompleted == true
            }.count
        }
        snapshot.addedWords = VocabularyHistory.shared.addedWords.count
        snapshot.masteredWords = VocabularyHistory.shared.masteredCardIDs.count
        snapshot.bestStreak = AchievementSnapshot.longestStreak(in: ReviewHistory.shared.days)

        achievements = ledger.reconcile(catalog: AchievementDefinition.catalog, snapshot: snapshot)
        pendingIDs = ledger.pendingIDs
    }

    func finishCelebration(_ id: String) {
        ledger.finishCelebration(id)
        pendingIDs = ledger.pendingIDs
    }
}

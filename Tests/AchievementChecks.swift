//
//  AchievementChecks.swift
//  LinguaFlow
//
//  Created by Кирилл on 04.11.2026.
//

import Foundation

@main
struct AchievementChecks {
    static func main() throws {
        let catalog = try JSONDecoder().decode([AchievementDefinition].self,
            from: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1])))
        func item(_ id: String) -> AchievementDefinition { catalog.first { $0.id == id }! }
        let suite = "LinguaFlow.AchievementChecks.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        var snapshot = AchievementSnapshot(lessonTotals: [1: 30, 2: 30, 3: 30])
        var ledger = AchievementLedger(defaults: defaults)
        assert(ledger.reconcile(catalog: catalog, snapshot: snapshot).allSatisfy { !$0.isEarned })
        assert(ledger.pendingIDs.isEmpty)

        snapshot.completedLessons = [1: 1]
        _ = ledger.reconcile(catalog: catalog, snapshot: snapshot)
        assert(ledger.pendingIDs == ["first-lesson"])
        ledger.finishCelebration("first-lesson")
        _ = ledger.reconcile(catalog: catalog, snapshot: snapshot)
        assert(ledger.pendingIDs.isEmpty, "An earned badge cannot pop up twice")

        snapshot.completedLessons = [1: 30, 2: 29, 3: 0]
        assert(snapshot.progress(for: item("level-complete")).current == 1)
        assert(snapshot.progress(for: item("level-2-complete")).current == 29)
        assert(snapshot.progress(for: item("level-3-complete")).current == 0)
        assert(snapshot.progress(for: item("all-lessons-complete")).current == 59)
        snapshot.completedLessons = [1: 30, 2: 30, 3: 30]
        assert(snapshot.progress(for: item("all-lessons-complete")).current == 90)

        snapshot.addedWords = 1000
        snapshot.bestStreak = 365
        snapshot.masteredWords = 100
        let states = ledger.reconcile(catalog: catalog, snapshot: snapshot)
        assert(states.allSatisfy(\.isEarned))
        assert(ledger.pendingIDs.count == 4, "One celebration per family after a large import")
        assert(Set(ledger.pendingIDs) == Set(["all-lessons-complete", "words-1000", "streak-365", "100-mastered-words"]))
        var reopened = AchievementLedger(defaults: defaults)
        assert(reopened.pendingIDs == ledger.pendingIDs, "Pending celebrations survive a restart")
        for id in reopened.pendingIDs { reopened.finishCelebration(id) }
        snapshot.addedWords = 0
        snapshot.bestStreak = 0
        snapshot.completedLessons = [:]
        snapshot.masteredWords = 0
        assert(reopened.reconcile(catalog: catalog, snapshot: snapshot).allSatisfy(\.isEarned))
        assert(reopened.pendingIDs.isEmpty, "Progress rollback never removes awards or repeats celebrations")

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        assert(AchievementSnapshot.longestStreak(in: ["2026-3-7", "2026-3-8", "2026-3-9"], calendar: calendar) == 3)
        assert(AchievementSnapshot.longestStreak(in: ["2026-10-31", "2026-11-1", "2026-11-2"], calendar: calendar) == 3)
        assert(AchievementSnapshot.longestStreak(in: ["2026-1-1", "2026-1-2", "2026-1-4", "2026-1-5", "2026-1-6"], calendar: calendar) == 3)

        let vocabulary = VocabularyHistory(defaults: defaults)
        vocabulary.record(word: "  Hello  WORLD ")
        vocabulary.record(word: "hello world")
        assert(vocabulary.addedWords.count == 1)
        let cardID = UUID()
        vocabulary.record(word: "hello world", masteredID: cardID)
        vocabulary.record(word: "hello world", masteredID: cardID)
        assert(vocabulary.masteredCardIDs.count == 1)
        assert(VocabularyHistory(defaults: defaults).addedWords == vocabulary.addedWords)
        print("Achievement checks passed: thresholds, all lessons, permanent awards, queue, restart, DST, vocabulary deduplication")
    }
}

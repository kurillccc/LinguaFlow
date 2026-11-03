//
//  Achievement.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import Foundation

struct AchievementDefinition: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let condition: String
    let category: String
    let threshold: Int?
    let levelId: Int?

    var assetName: String { "achievement-" + id }

    static let catalog: [AchievementDefinition] = {
        guard let url = Bundle.main.url(forResource: "achievements", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([AchievementDefinition].self, from: data) else {
            assertionFailure("Missing achievements catalog")
            return []
        }
        return items
    }()
}

struct AchievementSnapshot {
    var lessonTotals: [Int: Int] = [:]
    var completedLessons: [Int: Int] = [:]
    var addedWords = 0
    var masteredWords = 0
    var bestStreak = 0

    func progress(for achievement: AchievementDefinition) -> (current: Int, target: Int) {
        let target: Int
        let current: Int
        switch achievement.category {
        case "vocabulary":
            target = achievement.threshold ?? 1
            current = addedWords
        case "mastery":
            target = achievement.threshold ?? 1
            current = masteredWords
        case "streak":
            target = achievement.threshold ?? 1
            current = bestStreak
        default:
            if let level = achievement.levelId {
                target = max(lessonTotals[level] ?? 0, 1)
                current = completedLessons[level] ?? 0
            } else if achievement.id == "all-lessons-complete" {
                target = max(lessonTotals.values.reduce(0, +), 1)
                current = completedLessons.values.reduce(0, +)
            } else if achievement.id == "level-complete" {
                target = 1
                current = lessonTotals.contains { level, total in
                    total > 0 && (completedLessons[level] ?? 0) >= total
                } ? 1 : 0
            } else {
                target = 1
                current = completedLessons.values.reduce(0, +)
            }
        }
        return (min(max(current, 0), max(target, 1)), max(target, 1))
    }

    static func longestStreak(in days: Set<String>, calendar: Calendar = .current) -> Int {
        let dates = days.compactMap { key -> Date? in
            let parts = key.split(separator: "-").compactMap { Int($0) }
            guard parts.count == 3 else { return nil }
            return calendar.date(from: DateComponents(year: parts[0], month: parts[1], day: parts[2]))
        }.sorted()
        var best = 0
        var run = 0
        var previous: Date?
        for day in dates {
            if let previous, calendar.dateComponents([.day], from: previous, to: day).day == 1 {
                run += 1
            } else {
                run = 1
            }
            best = max(best, run)
            previous = day
        }
        return best
    }
}

struct AchievementState: Identifiable {
    let definition: AchievementDefinition
    let current: Int
    let target: Int
    let earnedAt: Date?
    var id: String { definition.id }
    var isEarned: Bool { earnedAt != nil }
    var fraction: Double { isEarned ? 1 : Double(current) / Double(max(target, 1)) }
    var progressText: String { "\(isEarned ? target : current) / \(target)" }
}

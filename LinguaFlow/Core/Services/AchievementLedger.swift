//
//  AchievementLedger.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import Foundation

/// Permanent awards and an ordered, persistent queue of celebrations.
struct AchievementLedger {
    private let defaults: UserDefaults
    private(set) var earned: [String: Date]
    private(set) var pendingIDs: [String]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let timestamps = defaults.dictionary(forKey: "achievements.earned") as? [String: Double] ?? [:]
        earned = timestamps.mapValues { Date(timeIntervalSince1970: $0) }
        pendingIDs = defaults.stringArray(forKey: "achievements.pending") ?? []
    }

    mutating func reconcile(catalog: [AchievementDefinition], snapshot: AchievementSnapshot,
                            at date: Date = .now) -> [AchievementState] {
        var newlyEarned: [AchievementDefinition] = []
        let states = catalog.map { definition in
            let progress = snapshot.progress(for: definition)
            if progress.current >= progress.target && earned[definition.id] == nil {
                earned[definition.id] = date
                newlyEarned.append(definition)
            }
            return AchievementState(definition: definition, current: progress.current,
                                    target: progress.target, earnedAt: earned[definition.id])
        }
        guard !newlyEarned.isEmpty else { return states }
        // Like Sober: celebrate the largest new milestone per family, at most five
        // screens after migration. Lower reached milestones are still earned forever.
        var celebrations: [AchievementDefinition] = []
        for definition in newlyEarned {
            if let index = celebrations.firstIndex(where: { $0.category == definition.category }) {
                if snapshot.progress(for: definition).target >= snapshot.progress(for: celebrations[index]).target {
                    celebrations[index] = definition
                }
            } else {
                celebrations.append(definition)
            }
        }
        for definition in celebrations.prefix(5) where !pendingIDs.contains(definition.id) {
            pendingIDs.append(definition.id)
        }
        persist()
        return states
    }

    mutating func finishCelebration(_ id: String) {
        pendingIDs.removeAll { $0 == id }
        persist()
    }

    private func persist() {
        defaults.set(earned.mapValues(\.timeIntervalSince1970), forKey: "achievements.earned")
        defaults.set(pendingIDs, forKey: "achievements.pending")
    }
}

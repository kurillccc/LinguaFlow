//
//  ReviewHistory.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import Foundation
import Combine

/// Calendar days are stored independently of cards, so deleting a word preserves history.
final class ReviewHistory: ObservableObject {
    static let shared = ReviewHistory()
    @Published private(set) var days: Set<String>
    private let defaults: UserDefaults
    private let key = "wordReviewDays"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        days = Set(defaults.stringArray(forKey: key) ?? [])
    }

    private func dayKey(_ date: Date, calendar: Calendar) -> String {
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        return "\(parts.year!)-\(parts.month!)-\(parts.day!)"
    }

    func recordReview(at date: Date = .now, calendar: Calendar = .current) {
        days.insert(dayKey(date, calendar: calendar))
        defaults.set(Array(days), forKey: key)
    }

    func reviewed(on date: Date, calendar: Calendar = .current) -> Bool {
        days.contains(dayKey(date, calendar: calendar))
    }

    func streak(at date: Date = .now, calendar: Calendar = .current) -> Int {
        var cursor = calendar.startOfDay(for: date)
        if !reviewed(on: cursor, calendar: calendar) {
            cursor = calendar.date(byAdding: .day, value: -1, to: cursor)!
        }
        var count = 0
        while reviewed(on: cursor, calendar: calendar) {
            count += 1
            cursor = calendar.date(byAdding: .day, value: -1, to: cursor)!
        }
        return count
    }
}

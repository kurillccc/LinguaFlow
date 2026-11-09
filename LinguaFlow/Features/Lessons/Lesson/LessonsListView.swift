//
//  LessonsListView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI
import Combine

struct LessonsListView: View {
    
    let level: Level
    @State private var progressCache: [String: LessonProgressEntity] = [:]
    @StateObject private var favorites = FavoriteLessonsStore.shared
    
    var lessons: [Lesson] { level.lessons }

    private var favoriteLessons: [Lesson] {
        lessons.filter { favorites.isFavorite($0) }
    }

    private var otherLessons: [Lesson] {
        lessons.filter { !favorites.isFavorite($0) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if !favoriteLessons.isEmpty {
                    sectionHeader("Избранное", icon: "bookmark.fill", count: favoriteLessons.count)
                    lessonRows(favoriteLessons)
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                }

                sectionHeader("Уроки уровня", icon: "headphones")
                lessonRows(otherLessons)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(16)
        }
        .appScreenTitle(level.title)
        .appBackButton()
        .background(Color(.systemGroupedBackground))
        .onAppear {
            progressCache = ProgressManager.shared.progressCache
        }
    }

    @ViewBuilder
    private func lessonRows(_ lessons: [Lesson]) -> some View {
        ForEach(lessons) { lesson in
            let progress = progressCache["\(lesson.levelId)_\(lesson.id)"]
            NavigationLink(destination: LessonPlayerScreen(level: level, lesson: lesson)) {
                LessonRowView(
                    lesson: lesson,
                    progress: progress?.toModel(),
                    accentColor: level.color
                )
            }
            .buttonStyle(.plain)

            Divider().padding(.leading, 76)
        }
    }

    private func sectionHeader(_ title: String, icon: String, count: Int? = nil) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(level.color)
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            if let count {
                Text("\(count)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(level.color)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(level.color.opacity(0.12), in: Capsule())
            }
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
}

//
//  AchievementsView.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject private var store = AchievementStore.shared
    @State private var selected: AchievementState?
    private var groups: [AchievementGroup] {
        let definitions: [(String, String, String, String, [String])] = [
            ("streak", "Серия повторений", "Повторяй слова каждый день", "flame.fill", ["streak"]),
            ("vocabulary", "Словарный запас", "Добавляй и запоминай новые слова", "character.book.closed.fill", ["vocabulary", "mastery"]),
            ("lessons", "Обучение", "Проходи уроки и открывай уровни", "headphones", ["lessons"])
        ]
        return definitions.compactMap { id, title, subtitle, icon, categories in
            let items = store.achievements.filter { categories.contains($0.definition.category) }
            guard !items.isEmpty else { return nil }
            return AchievementGroup(id: id, title: title, subtitle: subtitle, icon: icon, achievements: items)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    hero
                    if !store.nextAchievements.isEmpty { upNext }
                    ForEach(groups) { group in
                        AchievementSection(group: group) { selected = $0 }
                    }
                }
                .padding(16)
                .padding(.bottom, 12)
                .frame(maxWidth: 680)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .appScreenTitle("Достижения")
            .sheet(item: $selected) { achievement in
                AchievementDetailView(achievement: achievement)
                    .presentationDragIndicator(.visible)
            }
        }
        .tint(Tab.achievements.color)
    }

    private var hero: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text("ШАГ ЗА ШАГОМ")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Tab.home.color)
                Text(store.earnedCount == store.achievements.count && store.earnedCount > 0
                     ? "Все награды ваши!" : "Вы отлично идёте!")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                Text("Маленькие шаги. Большой прогресс.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ProgressView(value: Double(store.earnedCount), total: Double(max(store.achievements.count, 1)))
                    .tint(Tab.home.color)
                Text("Открыто: \(store.earnedCount) из \(store.achievements.count)")
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image("achievement-all-lessons-complete")
                .resizable()
                .scaledToFit()
                .frame(width: 112, height: 128)
                .accessibilityHidden(true)
        }
        .padding(18)
        .background(LinearGradient(colors: [Tab.home.color.opacity(0.18), Color(.secondarySystemGroupedBackground)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 24))
    }

    private var upNext: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Следующие награды", systemImage: "star.fill")
                .font(.headline)
                .foregroundStyle(Tab.home.color)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.nextAchievements) { achievement in
                        Button { selected = achievement } label: {
                            HStack(spacing: 10) {
                                AchievementBadge(achievement: achievement, size: 48)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(achievement.definition.name)
                                        .font(.subheadline.weight(.semibold))
                                        .lineLimit(2)
                                    Text(achievement.progressText)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                    ProgressView(value: achievement.fraction)
                                        .tint(Tab.home.color)
                                }
                            }
                            .frame(width: 220, alignment: .leading)
                            .padding(10)
                            .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 22))
    }
}

struct AchievementBadge: View {
    let achievement: AchievementState
    let size: CGFloat

    var body: some View {
        Image(achievement.definition.assetName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .saturation(achievement.isEarned ? 1 : 0)
            .opacity(achievement.isEarned ? 1 : 0.55)
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: achievement.isEarned ? "checkmark.circle.fill" : "lock.circle.fill")
                    .font(.system(size: max(16, size * 0.22)))
                    .foregroundStyle(achievement.isEarned ? Tab.home.color : Color.secondary)
                    .background(Color(.systemBackground), in: Circle())
            }
            .accessibilityHidden(true)
    }
}

private struct AchievementGroup: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let achievements: [AchievementState]
}

private struct AchievementSection: View {
    let group: AchievementGroup
    let select: (AchievementState) -> Void

    private var earnedCount: Int { group.achievements.filter(\.isEarned).count }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: group.icon)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Tab.home.color)
                    .frame(width: 44, height: 44)
                    .background(Tab.home.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 3) {
                    Text(group.title)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                    Text(group.subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 4)
                Text("\(earnedCount)/\(group.achievements.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(group.achievements) { achievement in
                        Button { select(achievement) } label: {
                            AchievementTile(achievement: achievement)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("achievement-" + achievement.id)
                    }
                }
            }
            .contentMargins(.trailing, 2)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 24))
    }
}

private struct AchievementTile: View {
    let achievement: AchievementState

    var body: some View {
        VStack(spacing: 10) {
            AchievementBadge(achievement: achievement, size: 96)
            Text(achievement.definition.name)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .multilineTextAlignment(.center)
                .frame(minHeight: 42)
            Text(achievement.definition.condition)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(minHeight: 62)
            ProgressView(value: achievement.fraction)
                .tint(Tab.home.color)
            Text(achievement.isEarned ? "Получено" : achievement.progressText)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(achievement.isEarned ? Tab.home.color : Color.secondary)
        }
        .padding(14)
        .frame(width: 168)
        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .combine)
    }
}

struct AchievementDetailView: View {
    let achievement: AchievementState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    AchievementBadge(achievement: achievement, size: 180)
                    Text(achievement.definition.name)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text(achievement.definition.condition)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    ProgressView(value: achievement.fraction)
                        .tint(Tab.home.color)
                    Text(achievement.isEarned ? "Достижение получено" : "Прогресс: \(achievement.progressText)")
                        .font(.subheadline.weight(.semibold))
                    if let date = achievement.earnedAt {
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .multilineTextAlignment(.center)
                .padding(28)
            }
            .appScreenTitle("Достижение")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Закрыть")
                }
            }
        }
    }
}

struct AchievementCelebrationView: View {
    let achievement: AchievementState
    let onContinue: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    Text("Поздравляем!")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text("Новое достижение открыто")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(achievement.definition.name)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(Tab.home.color)
                    Spacer(minLength: 16)
                    ZStack {
                        Circle()
                            .fill(Tab.home.color.opacity(0.12))
                            .frame(width: 220, height: 220)
                        Image(achievement.definition.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 280)
                            .frame(height: 280)
                            .shadow(color: Tab.home.color.opacity(0.2), radius: 20, y: 8)
                        Image(systemName: "sparkle")
                            .font(.system(size: 26))
                            .foregroundStyle(.orange)
                            .offset(x: 120, y: -100)
                        Image(systemName: "sparkle")
                            .font(.system(size: 18))
                            .foregroundStyle(Tab.home.color)
                            .offset(x: -118, y: 85)
                    }
                    .scaleEffect(appeared ? 1 : 0.8)
                    .opacity(appeared ? 1 : 0)
                    Spacer(minLength: 16)
                    Text(achievement.definition.condition)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Каждый шаг имеет значение. Продолжайте!")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button(action: onContinue) {
                        Text("Продолжить")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .foregroundStyle(.white)
                            .background(Tab.home.color, in: Capsule())
                    }
                }
                .multilineTextAlignment(.center)
                .padding(28)
                .frame(maxWidth: 520)
                .frame(minHeight: geometry.size.height)
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            withAnimation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.7)) { appeared = true }
        }
    }
}

//
//  HomeView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var showSettings = false
    @State private var showStreakShare = false

    @State private var showStudy = false
    @State private var showAddWord = false
    @ObservedObject private var cards = FlashcardStore.shared
    @ObservedObject private var history = ReviewHistory.shared
    @ObservedObject private var progress = ProgressManager.shared
    private let levels = (1...3).compactMap { LevelLoader.load(level: $0) }

    private var resume: (level: Level, lesson: Lesson)? {
        let lessons = levels.flatMap { level in level.lessons.map { (level: level, lesson: $0) } }
        if let last = lessons.first(where: {
            $0.level.id == progress.lastLevelId && $0.lesson.id == progress.lastLessonId
        }), progress.load(levelId: last.level.id, lessonId: last.lesson.id)?.isCompleted != true {
            return last
        }
        return lessons.first {
            progress.load(levelId: $0.level.id, lessonId: $0.lesson.id)?.isCompleted != true
        } ?? lessons.first
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    reviewBanner
                    courseBanner
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 16)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                header
                    .padding(.horizontal, 16)
                    .padding(.bottom, 6)
            }
            .background(Tab.home.color.opacity(0.09).ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .fullScreenCover(isPresented: $showStreakShare) {
                StreakShareView(streak: history.streak())
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showAddWord) {
                AddFlashcardView()
                    .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $showStudy) {
                FlashcardStudyView(cards: cards.cards)
            }
        }
    }

    private var reviewBanner: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ПОВТОРЕНИЕ СЛОВ")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                        Text("\(history.streak(at: context.date))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                        Text("дней подряд")
                            .font(.headline)
                            .foregroundStyle(Tab.home.color)
                    }
                    Spacer()
                    Image(systemName: "flame.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.orange.gradient)
                        .rotationEffect(.degrees(10))
                        .padding(.top, 16)
                        .accessibilityHidden(true)
                }
                Text(cards.cards.isEmpty
                     ? "Добавьте первые слова и начните свою серию"
                     : history.reviewed(on: context.date)
                        ? "Сегодня вы уже повторяли слова. Так держать!"
                        : "Несколько минут практики — ещё один день в серии")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    ForEach(0..<7) { offset in
                        let day = Calendar.current.date(byAdding: .day, value: offset - 6, to: context.date)!
                        let done = history.reviewed(on: day)
                        VStack(spacing: 6) {
                            Text(day.formatted(.dateTime.weekday(.abbreviated).locale(Locale(identifier: "ru_RU"))))
                                .font(.caption2.weight(.medium))
                            Group {
                                if done {
                                    Image(systemName: "flame.fill")
                                        .foregroundStyle(.orange.gradient)
                                } else {
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(Color.secondary.opacity(0.15))
                                }
                            }
                            .font(.body)
                        }
                        .frame(maxWidth: .infinity)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(day.formatted(date: .abbreviated, time: .omitted)): \(done ? "слова повторены" : "нет повторений")")
                    }
                }
                .padding(10)
                .background(Color(.systemBackground).opacity(0.7), in: RoundedRectangle(cornerRadius: 20))
                Button {
                    if cards.cards.isEmpty { showAddWord = true }
                    else { showStudy = true }
                } label: {
                    Text(cards.cards.isEmpty ? "Добавить слова" : "Повторить слова")
                        .padding(.horizontal, 28)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "arrow.right")
                                .padding(.trailing, 16)
                                .accessibilityHidden(true)
                        }
                        .padding(.vertical, 12)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .background(Tab.home.color, in: Capsule())
                }
            }
            .padding(18)
            .background {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.secondarySystemGroupedBackground))
                RoundedRectangle(cornerRadius: 28)
                    .fill(LinearGradient(colors: [Tab.home.color.opacity(0.2), .clear, Color.yellow.opacity(0.13)], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
    }

    @ViewBuilder
    private var courseBanner: some View {
        if let target = resume {
            let completed = target.level.lessons.filter {
                progress.load(levelId: target.level.id, lessonId: $0.id)?.isCompleted == true
            }.count
            NavigationLink {
                LessonPlayerScreen(level: target.level, lesson: target.lesson)
            } label: {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("ВАШ КУРС")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Image(systemName: "headphones")
                            .font(.system(size: 26))
                            .foregroundStyle(Tab.lessons.color)
                    }
                    Text(progress.lastLessonId == 0 ? "Начнём учиться?" : "Продолжим обучение")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text("\(target.level.title) · Урок \(target.lesson.id)")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Tab.lessons.color)
                    Text(target.lesson.title)
                        .font(.footnote)
                    ProgressView(value: Double(completed), total: Double(max(target.level.lessons.count, 1)))
                        .tint(Tab.lessons.color)
                    Text("Завершено уроков: \(completed) из \(target.level.lessons.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(progress.lastLessonId == 0 ? "Начать курс" : "Продолжить")
                    .padding(.horizontal, 28)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "play.fill")
                            .accessibilityHidden(true)
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(Tab.lessons.color, in: Capsule())
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 28))
            }
            .buttonStyle(.plain)
        }
    }

    private var header: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            HStack(spacing: 8) {
                Button {
                    showStreakShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 34, height: 34)
                        .background(Color(.systemBackground), in: Circle())
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Поделиться стриком повторения слов")

                Text(greeting(at: context.date))
                    .accessibilityIdentifier("home-greeting")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 34, height: 34)
                        .background(Color(.systemBackground), in: Circle())
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Настройки")
            }
            .foregroundStyle(.primary)
        }
    }

    private func greeting(at date: Date) -> String {
        switch Calendar.current.component(.hour, from: date) {
        case 5..<12: return "Доброе утро ☀️"
        case 12..<18: return "Добрый день 🌤️"
        case 18..<23: return "Добрый вечер 🌙"
        default: return "Доброй ночи ✨"
        }
    }
}

#Preview {
    HomeView()
}

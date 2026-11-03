//
//  HomeView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var showSettings = false

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
                VStack(spacing: 24) {
                    header
                    reviewBanner
                    courseBanner
                }
                .padding(20)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .background(Tab.home.color.opacity(0.09).ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .presentationDragIndicator(.visible)
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
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                        Text("дней подряд")
                            .font(.title3.bold())
                            .foregroundStyle(Tab.home.color)
                    }
                    Spacer()
                    Image(systemName: "flame.fill")
                        .font(.system(size: 66))
                        .foregroundStyle(.orange.gradient)
                        .rotationEffect(.degrees(10))
                        .padding(.top, 24)
                        .accessibilityHidden(true)
                }
                Text(cards.cards.isEmpty
                     ? "Добавьте первые слова и начните свою серию"
                     : history.reviewed(on: context.date)
                        ? "Сегодня вы уже повторяли слова. Так держать!"
                        : "Несколько минут практики — ещё один день в серии")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    ForEach(0..<7) { offset in
                        let day = Calendar.current.date(byAdding: .day, value: offset - 6, to: context.date)!
                        let done = history.reviewed(on: day)
                        VStack(spacing: 10) {
                            Text(day.formatted(.dateTime.weekday(.abbreviated).locale(Locale(identifier: "ru_RU"))))
                                .font(.caption2.weight(.medium))
                            Image(systemName: done ? "checkmark.circle.fill" : "circle.fill")
                                .font(.title3)
                                .foregroundStyle(done ? Tab.home.color : Color.secondary.opacity(0.15))
                        }
                        .frame(maxWidth: .infinity)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(day.formatted(date: .abbreviated, time: .omitted)): \(done ? "слова повторены" : "нет повторений")")
                    }
                }
                .padding(14)
                .background(Color(.systemBackground).opacity(0.7), in: RoundedRectangle(cornerRadius: 20))
                Button {
                    if cards.cards.isEmpty { showAddWord = true }
                    else { showStudy = true }
                } label: {
                    Label(cards.cards.isEmpty ? "Добавить слова" : "Повторить слова", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .background(Tab.home.color, in: Capsule())
                }
            }
            .padding(24)
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
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("ВАШ КУРС")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Image(systemName: "headphones")
                            .font(.system(size: 34))
                            .foregroundStyle(Tab.lessons.color)
                    }
                    Text(progress.lastLessonId == 0 ? "Начнём учиться?" : "Продолжим обучение")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text("\(target.level.title) · Урок \(target.lesson.id)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Tab.lessons.color)
                    Text(target.lesson.title)
                        .font(.subheadline)
                    ProgressView(value: Double(completed), total: Double(max(target.level.lessons.count, 1)))
                        .tint(Tab.lessons.color)
                    Text("Завершено уроков: \(completed) из \(target.level.lessons.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack {
                        Text(progress.lastLessonId == 0 ? "Начать курс" : "Продолжить")
                        Spacer()
                        Image(systemName: "play.fill")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(Tab.lessons.color, in: Capsule())
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 28))
            }
            .buttonStyle(.plain)
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            TimelineView(.periodic(from: .now, by: 60)) { context in
                Text(greeting(at: context.date))
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: 48, height: 48)
                    .background(Color(.systemBackground), in: Circle())
            }
            .accessibilityLabel("Настройки")
        }
        .padding(.vertical, 8)
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

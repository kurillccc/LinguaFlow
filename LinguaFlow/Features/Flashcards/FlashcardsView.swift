//
//  FlashcardsView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.09.2026.
//

import SwiftUI

/// Экран "Практика": список карточек для заучивания слов, созданных пользователем,
/// с возможностью добавить новую карточку и запустить сессию повторения.
struct FlashcardsView: View {

    @ObservedObject private var store = FlashcardStore.shared
    @State private var showAddSheet = false
    @State private var showStudySheet = false

    private let accentColor = Tab.practice.color

    private var learnedCount: Int {
        store.cards.filter { $0.isLearned }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                if store.cards.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            progressHeader

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(store.cards) { card in
                                    FlashcardTileView(card: card, accentColor: accentColor)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                store.delete(card)
                                            } label: {
                                                Label("Удалить", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                AppTabHeader(title: "Практика") {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    .accessibilityLabel("Добавить слово")
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 12)
                .background(Color(.systemGroupedBackground))
            }
            .sheet(isPresented: $showAddSheet) {
                AddFlashcardView()
                    .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $showStudySheet) {
                FlashcardStudyView(cards: store.cards)
            }
        }
        .tint(accentColor)
    }

    private var progressHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(store.cards.count) карточек")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text("\(learnedCount) выучено")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button {
                showStudySheet = true
            } label: {
                Label("Учить", systemImage: "play.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
        )
        .padding(.horizontal, 20)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "rectangle.stack.badge.plus")
                .font(.system(size: 56))
                .foregroundColor(accentColor.opacity(0.5))
            Text("Пока нет карточек")
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text("Добавляйте слова, которые хотите выучить, и повторяйте их с помощью карточек")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                showAddSheet = true
            } label: {
                Label("Добавить слово", systemImage: "plus")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
        .padding(24)
    }
}

#Preview {
    FlashcardsView()
}

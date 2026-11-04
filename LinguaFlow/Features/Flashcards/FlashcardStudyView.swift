//
//  FlashcardStudyView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.09.2026.
//

import SwiftUI

/// Полноэкранная сессия повторения карточек: слово → (тап) → перевод → оценка "Знаю/Не знаю".
struct FlashcardStudyView: View {

    let cards: [Flashcard]

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = FlashcardStore.shared

    @State private var currentIndex = 0
    @State private var isFlipped = false

    private let accentColor = Tab.practice.color

    private var currentCard: Flashcard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                if let card = currentCard {
                    studyContent(for: card)
                } else {
                    completionState
                }
            }
            .appScreenTitle("Изучение")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Закрыть")
                }
            }
        }
        .tint(accentColor)
    }

    private func studyContent(for card: Flashcard) -> some View {
        VStack(spacing: 32) {
            Text("\(currentIndex + 1) из \(cards.count)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
                    .shadow(color: accentColor.opacity(0.15), radius: 16, x: 0, y: 6)

                VStack(spacing: 12) {
                    Text(isFlipped ? card.translation : card.word)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)

                    if isFlipped, let example = card.example {
                        Text(example)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }

                    Text(isFlipped ? "Перевод" : "Нажмите, чтобы увидеть перевод")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.top, 8)
                }
                .padding(24)
                .transition(.opacity)
                .id(isFlipped)
            }
            .frame(height: 260)
            .padding(.horizontal, 24)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFlipped.toggle()
                }
            }

            if isFlipped {
                HStack(spacing: 16) {
                    Button {
                        answer(knew: false)
                    } label: {
                        Label("Не знаю", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red.opacity(0.12))
                            .foregroundColor(.red)
                            .clipShape(Capsule())
                    }

                    Button {
                        answer(knew: true)
                    } label: {
                        Label("Знаю", systemImage: "checkmark")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(accentColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer()
        }
        .padding(.top, 24)
    }

    private var completionState: some View {
        VStack(spacing: 16) {
            Image(systemName: "party.popper.fill")
                .font(.system(size: 56))
                .foregroundColor(accentColor)
            Text("Отлично!")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            Text("Вы повторили все карточки в этой сессии")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                dismiss()
            } label: {
                Text("Готово")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
        .padding(24)
    }

    private func answer(knew: Bool) {
        if let card = currentCard {
            store.markReviewed(card, knew: knew)
        }
        isFlipped = false
        currentIndex += 1
    }
}

#Preview {
    FlashcardStudyView(cards: [])
}

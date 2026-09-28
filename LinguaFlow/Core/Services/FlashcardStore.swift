//
//  FlashcardStore.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.09.2026.
//

import SwiftUI
import CoreData
import Combine

/// Хранилище карточек для заучивания слов. Отвечает за CRUD-операции
/// поверх Core Data и хранит закешированный список карточек для UI.
final class FlashcardStore: ObservableObject {

    static let shared = FlashcardStore()

    @Published private(set) var cards: [Flashcard] = []

    private var context: NSManagedObjectContext?

    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
        loadAll()
    }

    private func loadAll() {
        guard let context else { return }
        let request = FlashcardEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FlashcardEntity.createdAt, ascending: false)]
        let results = (try? context.fetch(request)) ?? []

        DispatchQueue.main.async {
            self.cards = results.map { $0.toModel() }
        }
    }

    func add(word: String, translation: String, example: String?) {
        guard let context else { return }

        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTranslation = translation.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedExample = example?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedWord.isEmpty, !trimmedTranslation.isEmpty else { return }

        context.perform {
            let entity = FlashcardEntity(context: context)
            entity.id = UUID()
            entity.word = trimmedWord
            entity.translation = trimmedTranslation
            entity.example = (trimmedExample?.isEmpty ?? true) ? nil : trimmedExample
            entity.createdAt = Date()
            entity.box = 0

            try? context.save()
            self.loadAll()
        }
    }

    func delete(_ card: Flashcard) {
        guard let context else { return }

        context.perform {
            let request = FlashcardEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", card.id as CVarArg)

            if let entity = try? context.fetch(request).first {
                context.delete(entity)
                try? context.save()
                self.loadAll()
            }
        }
    }

    /// Обновляет "коробку" карточки после сессии повторения:
    /// правильный ответ продвигает её к статусу "выучено", неправильный — сбрасывает.
    func markReviewed(_ card: Flashcard, knew: Bool) {
        guard let context else { return }

        context.perform {
            let request = FlashcardEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", card.id as CVarArg)

            guard let entity = try? context.fetch(request).first else { return }

            entity.box = knew ? min(entity.box + 1, Int16(Flashcard.masteredBox)) : 0
            entity.lastReviewedAt = Date()

            try? context.save()
            self.loadAll()
        }
    }
}

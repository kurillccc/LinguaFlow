//
//  ProgressManager.swift
//  LinguaFlow
//
//  Created by Кирилл on 09.06.2026.
//

import SwiftUI
import CoreData
import Combine

final class ProgressManager: ObservableObject {

    static let shared = ProgressManager()
    
    @Published private(set) var progressCache: [Int: LessonProgressEntity] = [:]

    private var context: NSManagedObjectContext?
    
    func savePosition(lessonId: Int, levelId: Int, lastPosition: Double) {
        guard let context else { return }
        print("💾 savePosition lessonId: \(lessonId), position: \(lastPosition)")
        context.perform {
            let request = LessonProgressEntity.fetchRequest()
            request.predicate = NSPredicate(format: "lessonId == %d", lessonId)
            
            let existing = try? context.fetch(request).first
            let entity = existing ?? LessonProgressEntity(context: context)
            
            entity.lessonId = Int64(lessonId)
            entity.levelId = Int64(levelId)
            entity.lastPosition = lastPosition
            
            try? context.save()
        }
    }
    
    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
        loadAll()
    }
    private func loadAll() {
        guard let context else { return }
        let request = LessonProgressEntity.fetchRequest()
        let results = (try? context.fetch(request)) ?? []
        print("📦 loadAll: найдено \(results.count) записей")
        for r in results {
            print("   lessonId: \(r.lessonId), lastPosition: \(r.lastPosition), isCompleted: \(r.isCompleted)")
        }
        var cache: [Int: LessonProgressEntity] = [:]
        for entity in results {
            cache[Int(entity.lessonId)] = entity
        }
        DispatchQueue.main.async {
            self.progressCache = cache
        }
    }

    func save(lessonId: Int, levelId: Int, isCompleted: Bool, lastPosition: Double) {
        guard let context else { return }
        
        context.perform {
            let request = LessonProgressEntity.fetchRequest()
            request.predicate = NSPredicate(format: "lessonId == %d", lessonId)
            
            let existing = try? context.fetch(request).first
            let entity = existing ?? LessonProgressEntity(context: context)
            
            entity.lessonId = Int64(lessonId)
            entity.levelId = Int64(levelId)
            entity.isCompleted = isCompleted
            entity.lastPosition = lastPosition
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.progressCache[lessonId] = entity
                }
                print("✅ saved lessonId:", lessonId, "isCompleted:", isCompleted)
            } catch {
                print("❌ save error:", error)
            }
        }
    }

    func load(lessonId: Int) -> LessonProgressEntity? {
        let result = progressCache[lessonId]
        print("📖 load lessonId: \(lessonId), found: \(result != nil), lastPosition: \(result?.lastPosition ?? -1)")
        return result
    }
    
}

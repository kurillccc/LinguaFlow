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
    
    @Published private(set) var progressCache: [String: LessonProgressEntity] = [:]
    
    private var context: NSManagedObjectContext?
    
    func savePosition(lessonId: Int, levelId: Int, lastPosition: Double) {
        guard let context else { return }

        context.perform {
            let request = LessonProgressEntity.fetchRequest()
            request.predicate = NSPredicate(
                format: "lessonId == %d AND levelId == %d",
                lessonId,
                levelId
            )

            let existing = try? context.fetch(request).first
            let entity = existing ?? LessonProgressEntity(context: context)

            entity.lessonId = Int64(lessonId)
            entity.levelId = Int64(levelId)
            entity.lastPosition = lastPosition

           try? context.save()

            let key = "\(levelId)_\(lessonId)"

            DispatchQueue.main.async {
                self.progressCache[key] = entity
            }
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
        
        var cache: [String: LessonProgressEntity] = [:]

        for entity in results {
            let key = "\(entity.levelId)_\(entity.lessonId)"
            cache[key] = entity
        }
        DispatchQueue.main.async {
            self.progressCache = cache
        }
    }

    func save(lessonId: Int, levelId: Int, isCompleted: Bool, lastPosition: Double) {
        guard let context else { return }
        
        context.perform {
            let request = LessonProgressEntity.fetchRequest()
            request.predicate = NSPredicate(
                format: "lessonId == %d AND levelId == %d",
                lessonId,
                levelId
            )
            
            let existing = try? context.fetch(request).first
            let entity = existing ?? LessonProgressEntity(context: context)
            
            entity.lessonId = Int64(lessonId)
            entity.levelId = Int64(levelId)
            entity.isCompleted = isCompleted
            entity.lastPosition = lastPosition
            
            try? context.save()
            
            let key = "\(levelId)_\(lessonId)"
            DispatchQueue.main.async {
                self.progressCache[key] = entity
            }
        }
    }

    func load(levelId: Int, lessonId: Int) -> LessonProgressEntity? {
        let key = "\(levelId)_\(lessonId)"
        return progressCache[key]
    }
    
}

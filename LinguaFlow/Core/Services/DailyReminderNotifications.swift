//
//  DailyReminderNotifications.swift
//  LinguaFlow
//
//  Created by Кирилл on 07.11.2026.
//

import UserNotifications

final class DailyReminderNotifications {
    static let shared = DailyReminderNotifications()

    private let center = UNUserNotificationCenter.current()
    private let requestID = "linguaflow.daily-review"

    private init() {}

    func update(enabled: Bool, hour: Int, completion: @escaping (Bool) -> Void) {
        guard enabled else {
            center.removePendingNotificationRequests(withIdentifiers: [requestID])
            completion(true)
            return
        }

        center.getNotificationSettings { [weak self] settings in
            guard let self else {
                completion(false)
                return
            }

            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                self.schedule(hour: hour, completion: completion)
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
                    guard granted else {
                        completion(false)
                        return
                    }
                    self.schedule(hour: hour, completion: completion)
                }
            default:
                completion(false)
            }
        }
    }

    private func schedule(hour: Int, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "Пора повторить слова"
        content.body = "Пара минут практики — и серия продолжится."
        content.sound = .default

        var components = DateComponents()
        components.hour = min(max(hour, 0), 23)
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)

        center.removePendingNotificationRequests(withIdentifiers: [requestID])
        center.add(request) { error in
            completion(error == nil)
        }
    }
}

//
//  AchievementPresenter.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import SwiftUI
import UIKit

/// Wait until forms, study sessions, and lesson players close before celebrating.
/// UIKit presentation avoids competing with a SwiftUI sheet on another tab.
struct AchievementPresenter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Controller { Controller() }
    func updateUIViewController(_ uiViewController: Controller, context: Context) {}

    final class Controller: UIViewController {
        private var timer: Timer?
        private var showing = false

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                    self?.presentNextIfPossible()
                }
            }
        }

        private func presentNextIfPossible() {
            let store = AchievementStore.shared
            guard !showing, store.activeLessonIDs.isEmpty,
                  view.window?.windowScene?.activationState == .foregroundActive,
                  let root = view.window?.rootViewController,
                  root.presentedViewController == nil, !root.isBeingDismissed,
                  let id = store.pendingIDs.first,
                  let achievement = store.achievements.first(where: { $0.id == id }) else { return }
            showing = true
            let screen = UIHostingController(rootView: AchievementCelebrationView(achievement: achievement) { [weak self, weak root] in
                store.finishCelebration(id)
                root?.dismiss(animated: true) {
                    self?.showing = false
                }
            })
            screen.modalPresentationStyle = .fullScreen
            root.present(screen, animated: true)
        }

        deinit { timer?.invalidate() }
    }
}

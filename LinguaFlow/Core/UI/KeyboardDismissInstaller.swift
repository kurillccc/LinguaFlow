//
//  KeyboardDismissInstaller.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import SwiftUI
import UIKit

/// Window-level gesture also covers sheets. Never intercept taps inside an editor
/// and never cancel the button/scroll gesture that the user actually tapped.
struct KeyboardDismissInstaller: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Controller { Controller() }
    func updateUIViewController(_ uiViewController: Controller, context: Context) {}

    final class Controller: UIViewController, UIGestureRecognizerDelegate {
        private weak var installedWindow: UIWindow?
        private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            guard let window = view.window, installedWindow !== window else { return }
            installedWindow?.removeGestureRecognizer(tap)
            tap.cancelsTouchesInView = false
            tap.delegate = self
            window.addGestureRecognizer(tap)
            installedWindow = window
        }

        @objc private func hideKeyboard() { installedWindow?.endEditing(true) }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            var current = touch.view
            while let view = current {
                if view is UITextField || view is UITextView { return false }
                current = view.superview
            }
            return true
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { true }
    }
}

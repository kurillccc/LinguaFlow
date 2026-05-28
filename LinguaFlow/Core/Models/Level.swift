//
//  Level.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import Foundation
import SwiftUI

struct Level: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let description: String
    let color: Color
    let icon: String
    let lessonsCount: Int
}

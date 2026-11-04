//
//  AppTabHeader.swift
//  LinguaFlow
//
//  Created by Кирилл on 04.11.2026.
//

import SwiftUI

struct AppTabHeader<Trailing: View>: View {
    let title: String
    let trailing: Trailing

    init(title: String, @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.trailing = trailing()
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 8)
            trailing
        }
        .frame(maxWidth: .infinity, minHeight: 42, alignment: .leading)
    }
}

extension AppTabHeader where Trailing == EmptyView {
    init(_ title: String) {
        self.title = title
        self.trailing = EmptyView()
    }
}

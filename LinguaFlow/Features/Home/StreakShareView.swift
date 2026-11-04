//
//  StreakShareView.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import SwiftUI
import UIKit
import CoreTransferable
import UniformTypeIdentifiers

private struct StreakJPEG: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .jpeg) { item in
            SentTransferredFile(item.url)
        }
    }
}

struct StreakShareView: View {
    let streak: Int
    @Environment(\.dismiss) private var dismiss
    @State private var preview: UIImage?
    @State private var jpeg: StreakJPEG?
    @State private var exportFailed = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let preview {
                        Image(uiImage: preview)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                            .accessibilityLabel("Мой стрик повторения слов: \(streak) дней")
                    } else {
                        ProgressView()
                            .frame(height: 300)
                    }
                    Text("Каждый день — ещё один шаг вперёд.\nПоделитесь своей серией!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    if exportFailed {
                        Text("Не удалось подготовить изображение")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Button("Попробовать ещё раз", action: prepareImage)
                    }
                }
                .padding(20)
                .frame(maxWidth: 440)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .appScreenTitle("Мой стрик")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Закрыть")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if let jpeg, let preview {
                        ShareLink(item: jpeg, preview: SharePreview("Мой стрик в LinguaFlow", image: Image(uiImage: preview))) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .accessibilityLabel("Поделиться изображением стрика")
                    }
                }
            }
        }
        .task { prepareImage() }
    }

    @MainActor
    private func prepareImage() {
        exportFailed = false
        let renderer = ImageRenderer(content: StreakArtwork(streak: streak)
            .environment(\.colorScheme, .light)
            .environment(\.dynamicTypeSize, .medium))
        renderer.scale = 3
        renderer.isOpaque = true
        guard let image = renderer.uiImage, let data = image.jpegData(compressionQuality: 0.95) else {
            exportFailed = true
            return
        }
        do {
            let directory = FileManager.default.temporaryDirectory.appendingPathComponent("StreakShares", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let url = directory.appendingPathComponent("LinguaFlow-streak-\(UUID().uuidString).jpg")
            try data.write(to: url, options: .atomic)
            preview = UIImage(data: data)
            jpeg = StreakJPEG(url: url)
        } catch {
            exportFailed = true
        }
    }
}

private struct StreakArtwork: View {
    let streak: Int
    private let ink = Color(red: 0.08, green: 0.25, blue: 0.21)

    private var dayLabel: String {
        switch (streak % 100, streak % 10) {
        case (11...14, _): return "ДНЕЙ ПОДРЯД"
        case (_, 1): return "ДЕНЬ ПОДРЯД"
        case (_, 2...4): return "ДНЯ ПОДРЯД"
        default: return "ДНЕЙ ПОДРЯД"
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            Label("LinguaFlow", systemImage: "waveform")
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text(streak == 0 ? "НАЧАЛО МОЕЙ СЕРИИ" : "МОЯ СЕРИЯ ПОВТОРЕНИЙ")
                .font(.system(size: 12, weight: .bold))
                .tracking(1.5)
                .padding(.top, 10)
            ZStack {
                Circle()
                    .fill(.white.opacity(0.55))
                    .frame(width: 132, height: 132)
                Image(systemName: "flame.fill")
                    .font(.system(size: 86))
                    .foregroundStyle(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
            }
            Text("\(streak)")
                .font(.system(size: 92, weight: .heavy, design: .rounded))
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
            Text(dayLabel)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .tracking(2)
            Text(streak == 0 ? "Большие результаты начинаются\nс первого слова" : "Прокачиваю английский\nкаждый день 💪")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
            Text(streak == 0 ? "Присоединяйся!" : "Попробуй побить мой стрик!")
                .font(.system(size: 13, weight: .semibold))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.white.opacity(0.65), in: Capsule())
        }
        .foregroundStyle(ink)
        .padding(28)
        .frame(width: 360, height: 640)
        .background(LinearGradient(colors: [Color(red: 0.81, green: 0.95, blue: 0.87), Color(red: 0.94, green: 0.98, blue: 0.84)], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

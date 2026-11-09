//
//  AudioPlayerView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    
    @ObservedObject var audio: AudioPlayerManager
    let level: Level
 
    var body: some View {
        VStack(spacing: 0) {
            Divider()
 
            VStack(spacing: 14) {
 
                // Прогресс-бар
                VStack(spacing: 6) {
                    Slider(
                        value: Binding(
                            get: { audio.currentTime },
                            set: { audio.scrubTo($0) }
                        ),
                        in: 0...max(audio.duration, 1),
                        onEditingChanged: { editing in
                            if !editing && audio.isScrubbing {
                                audio.commitSeek()
                            }
                            audio.isScrubbing = editing
                        }
                    )
                    .tint(level.color)
                    .disabled(!audio.hasAudio)
 
                    HStack {
                        Text(formatTime(audio.currentTime))
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatTime(audio.duration))
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }

                if !audio.hasAudio {
                    Text("Аудио для урока недоступно")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
 
                // Кнопки управления
                HStack(spacing: 0) {
 
                    // Скорость
                    Menu {
                        Button("0.5x") { audio.setRate(0.5) }
                        Button("0.75x") { audio.setRate(0.75) }
                        Button("1.0x")  { audio.setRate(1.0) }
                        Button("1.25x") { audio.setRate(1.25) }
                        Button("1.5x")  { audio.setRate(1.5) }
                        Button("1.75x") { audio.setRate(1.75) }
                        Button("2.0x")  { audio.setRate(2.0) }
                    } label: {
                        Text(speedLabel(audio.playbackRate))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(level.color)
                            .frame(width: 52, height: 36)
                            .background(level.color.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!audio.hasAudio)
 
                    // -10 сек
                    Button {
                        audio.seek(by: -10)
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(.system(size: 26))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!audio.hasAudio)
 
                    // Play / Pause
                    Button {
                        audio.togglePlay()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(level.color)
                                .frame(width: 60, height: 60)
                                .shadow(color: level.color.opacity(0.4), radius: 10, x: 0, y: 4)
                            Image(systemName: audio.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .offset(x: audio.isPlaying ? 0 : 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!audio.hasAudio)
 
                    // +10 сек
                    Button {
                        audio.seek(by: 10)
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(.system(size: 26))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!audio.hasAudio)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }
 
    private func formatTime(_ seconds: Double) -> String {
        let s = Int(seconds)
        return String(format: "%d:%02d", s / 60, s % 60)
    }
 
    private func speedLabel(_ rate: Float) -> String {
        rate == rate.rounded() ? "\(Int(rate)).0x" : "\(rate)x"
    }
    
}

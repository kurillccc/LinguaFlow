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
                    .tint(level.color)
 
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
 
                // Кнопки управления
                HStack(spacing: 0) {
 
                    // Скорость
                    Menu {
                        Button("0.75x") { audio.setRate(0.75) }
                        Button("1.0x")  { audio.setRate(1.0) }
                        Button("1.25x") { audio.setRate(1.25) }
                        Button("1.5x")  { audio.setRate(1.5) }
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
 
                    // -10 сек
                    Button {
                        audio.seek(by: -10)
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(.system(size: 26))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
 
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
 
                    // +10 сек
                    Button {
                        audio.seek(by: 10)
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(.system(size: 26))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
 
                    Button {
                        // TODO: закладка
                    } label: {
                        Image(systemName: "bookmark")
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
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
        switch rate {
        case 0.75: return "0.75x"
        case 1.25: return "1.25x"
        case 1.5:  return "1.5x"
        case 2.0:  return "2.0x"
        default:   return "1.0x"
        }
    }
    
}

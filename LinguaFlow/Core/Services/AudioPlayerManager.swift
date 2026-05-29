//
//  AudioPlayerManager.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI
import AVFoundation
import Combine

class AudioPlayerManager: ObservableObject {
    
    private var player: AVAudioPlayer?
 
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var playbackRate: Float = 1.0
    
    private var timer: Timer?
    
    func load(lessonId: Int, levelId: Int, fileExtension: String = "mp3") {
        // Настройка аудио сессии
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ AudioSession error: \(error)")
        }
        
        let fileName = "\(lessonId)"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("⚠️ Аудио файл не найден: \(fileName).\(fileExtension)")
            duration = 180
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            player?.prepareToPlay()
            duration = player?.duration ?? 1
            print("✅ Плеер создан, длительность: \(player?.duration ?? 0)")
        } catch {
            print("❌ AudioPlayer error: \(error)")
        }
    }
 
    func togglePlay() {
        if isPlaying {
            player?.pause()
            stopTimer()
        } else {
            player?.rate = playbackRate
            player?.play()
            startTimer()
        }
        isPlaying.toggle()
    }
 
    func seek(by seconds: Double) {
        let newTime = max(0, min(currentTime + seconds, duration))
        player?.currentTime = newTime
        currentTime = newTime
    }
 
    func seekTo(_ time: Double) {
        player?.currentTime = time
        currentTime = time
    }
 
    func setRate(_ rate: Float) {
        playbackRate = rate
        if isPlaying {
            player?.rate = rate
        }
    }
 
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.player?.currentTime ?? self.currentTime
            if self.currentTime >= self.duration {
                self.isPlaying = false
                self.stopTimer()
            }
        }
    }
 
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

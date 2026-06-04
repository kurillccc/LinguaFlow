//
//  AudioPlayerManager.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI
import AVFoundation
import Combine

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    private var player: AVAudioPlayer?
    var onFinish: (() -> Void)? = nil
    
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var playbackRate: Float = 1.0
    
    private var timer: Timer?
    
    func load(lessonId: Int, levelId: Int, fileExtension: String = "mp3") {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: []  // пустой options — значит фоновое воспроизведение включено
            )
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
            player?.delegate = self
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
        
        if newTime >= duration {
            player?.currentTime = duration
            currentTime = duration
            if isPlaying {
                player?.pause()
                stopTimer()
                isPlaying = false
            }
            onFinish?()
            return
        }
        
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
            // ← всё, больше ничего здесь не нужно
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func stop() {
        player?.stop()
        player?.currentTime = 0
        stopTimer()
        isPlaying = false
        currentTime = 0
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.stopTimer()
            self.onFinish?()
        }
    }
    
}

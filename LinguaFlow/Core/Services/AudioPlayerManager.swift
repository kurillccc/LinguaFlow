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
    private var didFinish = false
    var onProgressUpdate: ((Double) -> Void)? = nil
    var isScrubbing = false
    
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var playbackRate: Float = 1.0
    @Published private(set) var hasAudio = false
    
    private var timer: Timer?
    
    func load(lessonId: Int, levelId: Int, fileExtension: String = "mp3") {
        didFinish = false
        isPlaying = false
        currentTime = 0
        hasAudio = false
        let savedRate = Float(UserDefaults.standard.object(forKey: "playbackSpeed") as? Double ?? 1.0)
        playbackRate = min(max(savedRate, 0.5), 2.0)
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
        let levelDirectory = "Audio/Level\(levelId)"
        let directories: [String?] = [nil, levelDirectory, "Resources/\(levelDirectory)", "Level\(levelId)"]
        guard let url = directories.lazy.compactMap({ directory in
            Bundle.main.url(forResource: fileName, withExtension: fileExtension, subdirectory: directory)
        }).first else {
            duration = 180
            return
        }

        player = try? AVAudioPlayer(contentsOf: url)
        guard let player else {
            duration = 180
            return
        }
        player.delegate = self
        player.enableRate = true
        player.rate = playbackRate
        hasAudio = player.prepareToPlay()
        duration = player.duration
    }
    
    func togglePlay() {
        if isPlaying {
            player?.pause()
            stopTimer()
            isPlaying = false
        } else {
            guard let player, hasAudio else { return }
            if didFinish || currentTime >= duration - 0.1 {
                player.currentTime = 0
                currentTime = 0
                didFinish = false
            }
            player.rate = playbackRate
            guard player.play() else { return }
            startTimer()
            isPlaying = true
        }
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
            if !didFinish {
                didFinish = true
                onFinish?()
            }
            return
        }

        didFinish = false
        player?.currentTime = newTime
        currentTime = newTime
    }
    
    func seekTo(_ time: Double) {
        let clampedTime = max(0, min(time, duration))
        didFinish = false
        player?.currentTime = clampedTime
        currentTime = clampedTime
    }
    
    func setRate(_ rate: Float) {
        guard (0.5...2.0).contains(rate) else { return }
        playbackRate = rate
        UserDefaults.standard.set(Double(rate), forKey: "playbackSpeed")
        if isPlaying {
            player?.rate = rate
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.player?.currentTime ?? self.currentTime
            self.onProgressUpdate?(self.currentTime)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        self.currentTime = self.player?.currentTime ?? self.currentTime
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
            guard !self.didFinish else { return }
            self.didFinish = true
            self.isPlaying = false
            self.stopTimer()
            if flag { self.onFinish?() }
        }
    }
    
    func scrubTo(_ time: Double) {
        isScrubbing = true
        let clampedTime = min(time, duration)
        if clampedTime < duration - 2.0 { didFinish = false }
        player?.currentTime = clampedTime
        currentTime = clampedTime
    }

    func commitSeek() {
        onProgressUpdate?(currentTime)
        
        guard !didFinish else { return }
        if currentTime >= duration - 2.0 {
            didFinish = true
            if isPlaying {
                player?.pause()
                stopTimer()
                isPlaying = false
            }
            onFinish?()
        } else {
            didFinish = false
        }
    }
    
}

//
//  MusicPlayer.swift
//  Scoundrel
//
//  Created by David Freeman on 2/26/25.
//

import SwiftUI
import AVFoundation

class MusicPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @AppStorage(UserDefaultsKeys().backgroundMusicMuted) private var backgroundMusicMuted: Bool = false
    
    @Published var isPlaying: Bool = false {
        willSet {
            backgroundMusicMuted = !newValue
            
            if newValue == true {
                playRandomSong()
            } else {
                pauseMusic()
            }
        }
    }
    
    let songs: [String] = [
            "Knights in Shadows",
            "The Hollow Crown",
            "Wanderer's Requiem",
            "Oaths Upon the Wind",
            "Ballad of the Wayfarer",
            "Legends of the Silver Road"
        ]

    var currentTrackIndex = 0

    var music = AVAudioPlayer()

    override init() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        super.init()
        setupNotifications()
    }
    
    func playRandomSong() {
        currentTrackIndex = Int.random(in: 0..<songs.count)
        playMusic()
    }

    func playMusic() {
        if let musicURL = Bundle.main.url(forResource: songs[currentTrackIndex], withExtension: "mp3") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
                music = audioPlayer
                music.delegate = self
                music.numberOfLoops = 0
                music.play()
            }
        }
    }
    
    func pauseMusic() {
        music.pause()
    }

    func nextTrack() {
        music.stop()
        
        currentTrackIndex += 1
        if currentTrackIndex >= songs.count {
            currentTrackIndex = 0
        }
        
        playMusic()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextTrack()
    }
    
    func setupNotifications() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: AVAudioSession.sharedInstance())
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }


        // Switch over the interruption type.
        switch type {
        case .began: // An interruption began. Update the UI as necessary.
            break
        case .ended: // An interruption ended. Resume playback, if appropriate.
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // An interruption ended. Resume playback.
                music.play()
            } else {
                // An interruption ended. Don't resume playback.
            }
        default: ()
        }
    }
}

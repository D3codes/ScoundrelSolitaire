//
//  MusicPlayer.swift
//  Scoundrel
//
//  Created by David Freeman on 2/26/25.
//

import Foundation
import SwiftUI
import AVFoundation

class MusicPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isPlaying: Bool = false {
        willSet {
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
            "Oaths Upon the Wind"
        ]

    var currentTrackIndex = 0

    var music = AVAudioPlayer()

    override init() {
        super.init()
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
}

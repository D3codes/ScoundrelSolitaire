//
//  ControlBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI
import GameKit
import AVFAudio

struct ControlBarView: View {
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var gameKitHelper: GameKitHelper
    
    @State var page2Sound: AVAudioPlayer?
    
    func initializeSounds() {
        do {
            page2Sound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page2.mp3", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }
    }
    
    @State var isPresentingSettings: Bool = false
    @State var showSignInPopup: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: {
                    if !soundEffectsMuted { page2Sound?.play() }
                    isPresentingSettings = true
                },label: {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 50, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                })
                
                Spacer()
                
                Text("SCOUNDREL")
                    .font(.custom("MorrisRoman-Black", size: 30))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                Spacer()
                
                Button(action: {
                    GKAccessPoint.shared.trigger(
                        leaderboardID: GameKitHelper.Leaderboard.ScoundrelAllTimeHighScore.rawValue,
                        playerScope: .global,
                        timeScope: .allTime
                    ) {}
                },label: {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 50, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)

                        Image(systemName: "trophy.fill")
                            .foregroundStyle(gameKitHelper.localPlayerIsAuthenticated ? .white : .black)
                            .font(.title2)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                })
                .disabled(!gameKitHelper.localPlayerIsAuthenticated)
                .blur(radius: gameKitHelper.localPlayerIsAuthenticated ? 0 : 0.5)
                .onTapGesture {
                    if !gameKitHelper.localPlayerIsAuthenticated {
                        showSignInPopup = true
                    }
                }
                .popover(isPresented: $showSignInPopup) {
                    Text("Sign in to Game Center to view Leaderboard")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(
            Image("stoneSlab2")
                .resizable()
                .ignoresSafeArea()
                .shadow(color: .black, radius: 15, x: 0, y: 5)
        )
        .sheet(isPresented: $isPresentingSettings) {
            SettingsView(musicPlayer: musicPlayer)
        }
        .onAppear() { initializeSounds() }
    }
}

#Preview {
    struct ControlBarView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        @StateObject var gameKitHelper = GameKitHelper()
        
        var body: some View {
            ControlBarView(
                musicPlayer: musicPlayer,
                gameKitHelper: gameKitHelper
            )
        }
    }
    
    return ControlBarView_Preview()
}

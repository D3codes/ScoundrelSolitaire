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
    var settingsIsControllerFocused: Bool = false
    var leaderboardIsControllerFocused: Bool = false
    var showSettings: () -> Void
    var showLeaderboard: () -> Void
    
    @State var page2Sound: AVAudioPlayer?
    
    func initializeSounds() {
        do {
            page2Sound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page2.mp3", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }
    }
    
    @State var showSignInPopup: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: {
                    if !soundEffectsMuted { page2Sound?.play() }
                    showSettings()
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
                .controllerFocused(settingsIsControllerFocused)
                
                Spacer()
                
                Text("SCOUNDREL")
                    .font(.custom("MorrisRoman-Black", size: 30))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                Spacer()
                
                Button(action: {
                    if !soundEffectsMuted { page2Sound?.play() }
                    showLeaderboard()
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
                .controllerFocused(leaderboardIsControllerFocused)
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
                gameKitHelper: gameKitHelper,
                showSettings: {},
                showLeaderboard: {}
            )
        }
    }
    
    return ControlBarView_Preview()
}

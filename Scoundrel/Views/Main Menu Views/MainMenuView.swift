//
//  MainMenuView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var gameKitHelper: GameKitHelper
    @ObservedObject var game: Game
    
    var startGame: () -> Void
    var resumeGame: () -> Void
    
    @State var showHowToModal: Bool = false
    @State var showCreditsModal: Bool = false
    
    @State var page2Sound: AVAudioPlayer?
    
    func initializeSounds() {
        do {
            page2Sound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page2.mp3", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                TitleBarView()
                
                Spacer()
                Spacer()
                
                if game.score > 0 && !game.gameOver {
                    ResumeButtonView(game: game, resumeGame: resumeGame)
                }
                
                PlankButtonView(text: "New Game", action: startGame)
                    .padding(.bottom, 40)
                
                PlankButtonView(text: "How to Play", action: {
                    showHowToModal = true
                    if !soundEffectsMuted { page2Sound?.play() }
                })
                
                PlankButtonView(text: "Credits", action: {
                    showCreditsModal = true
                    if !soundEffectsMuted { page2Sound?.play() }
                })
                
                Spacer()
                
                ControlBarView(
                    musicPlayer: musicPlayer,
                    gameKitHelper: gameKitHelper
                )
            }
        }
        .sheet(isPresented: $showHowToModal) {
            HowToView()
                .onAppear { gameKitHelper.hideAccessPoint() }
                .onDisappear { gameKitHelper.showAccessPoint() }
        }
        .sheet(isPresented: $showCreditsModal) {
            CreditsView()
                .onAppear { gameKitHelper.hideAccessPoint() }
                .onDisappear { gameKitHelper.showAccessPoint() }
        }
        .onAppear { initializeSounds() }
    }
}

#Preview {
    struct MainMenuView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        @StateObject var gameKitHelper = GameKitHelper()
        
        var body: some View {
            MainMenuView(
                musicPlayer: musicPlayer,
                gameKitHelper: gameKitHelper,
                game: Game(),
                startGame: {},
                resumeGame: {}
            )
        }
    }
    
    return MainMenuView_Preview()
}

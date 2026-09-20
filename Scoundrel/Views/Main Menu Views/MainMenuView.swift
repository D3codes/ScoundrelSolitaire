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
    @State var showStatsModal: Bool = false
    
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
                ControlBarView(
                    musicPlayer: musicPlayer,
                    gameKitHelper: gameKitHelper
                )
                
                Spacer()
                
                ViewThatFits {
                    VStack {
                        if game.gameState != .GameOver && game.gameState != .Created {
                            ResumeButtonView(game: game, resumeGame: resumeGame)
                        }
                        
                        PlankButtonView(text: "New Game", action: startGame)
                            .padding(.bottom, 40)
                        
                        PlankButtonView(text: "How to Play", action: {
                            showHowToModal = true
                            if !soundEffectsMuted { page2Sound?.play() }
                        })
                        
                        PlankButtonView(text: "Stats", action: {
                            showStatsModal = true
                            if !soundEffectsMuted { page2Sound?.play() }
                        })
                    }
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            PlankButtonView(text: "New Game", action: startGame)
                                .padding(.bottom, 40)
                            
                            PlankButtonView(text: "How to Play", action: {
                                showHowToModal = true
                                if !soundEffectsMuted { page2Sound?.play() }
                            })
                            
                            PlankButtonView(text: "Stats", action: {
                                showStatsModal = true
                                if !soundEffectsMuted { page2Sound?.play() }
                            })
                        }

                        if game.gameState != .GameOver && game.gameState != .Created {
                            Spacer()
                            ResumeButtonView(game: game, resumeGame: resumeGame)
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showHowToModal) {
            HowToView(dismiss: { showHowToModal = false })
        }
        .sheet(isPresented: $showStatsModal) {
            StatsView(dismiss: { showStatsModal = false }, gameKitHelper: game.gameKitHelper)
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

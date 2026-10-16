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

    @ViewBuilder
    private var menuActions: some View {
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
    }

    @available(iOS 27.1, *)
    @ViewBuilder
    private func foldAwareMenu(in geometry: GeometryProxy, fold: ReservedRegion) -> some View {
        let isLandscape: Bool = fold.frame.height > fold.frame.width
        let width: CGFloat = isLandscape ? max(0, geometry.size.width - fold.frame.maxX) : geometry.size.width
        let height: CGFloat = isLandscape ? geometry.size.height : max(0, geometry.size.height - fold.frame.maxY)
        let alignment: Alignment = isLandscape ? .trailing : .bottom
        
        menuActions
            .frame(width: width, height: height)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    var body: some View {
        GeometryReader { geometry in
            if #available(iOS 27.1, *), let fold = geometry.dividingReservedRegion {
                let isLandscape: Bool = fold.frame.height > fold.frame.width
                
                VStack {
                    ControlBarView(
                        musicPlayer: musicPlayer,
                        gameKitHelper: gameKitHelper,
                        showSpacer: isLandscape
                    )
                    
                    foldAwareMenu(in: geometry, fold: fold)
                }
            } else {
                VStack {
                    ControlBarView(
                        musicPlayer: musicPlayer,
                        gameKitHelper: gameKitHelper,
                        showSpacer: false
                    )
                    
                    menuActions
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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

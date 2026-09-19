//
//  ModalOverlayView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/15/25.
//

import SwiftUI

struct ModalOverlayView: View {
    @ObservedObject var game: Game
    var resumeGame: () -> Void
    var nextDungeon: () -> Void
    var newGame: () -> Void
    var mainMenu: () -> Void
    var controllerSelection: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            ZStack {
                if game.gameState == .GameOver || game.gameState == .Paused || game.gameState == .DungeonBeat {
                    Rectangle()
                        .ignoresSafeArea(.all)
                        .foregroundStyle(.ultraThinMaterial)
                        .opacity(0.7)
                }
                
                switch game.gameState {
                case .DungeonBeat:
                    if isLandscape {
                        HStack {
                            if game.gameOverModalAchievement != nil {
                                AchievementBannerView(
                                    achievement: game.gameOverModalAchievement!,
                                    tall: true
                                )
                            }
                            
                            DungeonBeatModalView(
                                game: game,
                                nextDungeon: nextDungeon,
                                isControllerFocused: controllerSelection == 0
                            )
                        }
                        .transition(.opacityAndMoveFromBottom)
                    } else {
                        VStack {
                            if game.gameOverModalAchievement != nil {
                                AchievementBannerView(
                                    achievement: game.gameOverModalAchievement!,
                                    tall: false
                                )
                            }
                            
                            DungeonBeatModalView(
                                game: game,
                                nextDungeon: nextDungeon,
                                isControllerFocused: controllerSelection == 0
                            )
                        }
                        .transition(.opacityAndMoveFromBottom)
                    }
                case .GameOver:
                    if isLandscape {
                        HStack {
                            if game.gameOverModalAchievement != nil {
                                AchievementBannerView(
                                    achievement: game.gameOverModalAchievement!,
                                    tall: true
                                )
                            }
                            
                            GameOverModalView(
                                game: game,
                                newGame: newGame,
                                mainMenu: mainMenu,
                                controllerSelection: controllerSelection
                            )
                        }
                        .transition(.opacityAndMoveFromBottom)
                    } else {
                        VStack {
                            if game.gameOverModalAchievement != nil {
                                AchievementBannerView(
                                    achievement: game.gameOverModalAchievement!,
                                    tall: false
                                )
                            }
                            
                            GameOverModalView(
                                game: game,
                                newGame: newGame,
                                mainMenu: mainMenu,
                                controllerSelection: controllerSelection
                            )
                        }
                        .transition(.opacityAndMoveFromBottom)
                    }
                case .Paused:
                    PauseModalView(
                        continueGame: resumeGame,
                        newGame: newGame,
                        mainMenu: mainMenu,
                        controllerSelection: controllerSelection
                    )
                    .transition(.opacityAndMoveFromBottom)
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    struct ModalOverlayView_Preview: View {
        var game: Game = Game()
        
        var body: some View {
            ModalOverlayView(
                game: game,
                resumeGame: { },
                nextDungeon: { },
                newGame: { },
                mainMenu: { }
            )
            .onAppear {
                game.gameState = .GameOver
                game.gameOverModalAchievement = .CowardsNeedNotApply
            }
        }
    }
    
    return ModalOverlayView_Preview()
}

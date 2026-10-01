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

    private var pauseModal: some View {
        PauseModalView(
            continueGame: resumeGame,
            newGame: newGame,
            mainMenu: mainMenu
        )
    }

    @ViewBuilder
    private func dungeonBeatModal(isLandscape: Bool) -> some View {
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
                    nextDungeon: nextDungeon
                )
            }
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
                    nextDungeon: nextDungeon
                )
            }
        }
    }

    @ViewBuilder
    private func gameOverModal(isLandscape: Bool) -> some View {
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
                    mainMenu: mainMenu
                )
            }
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
                    mainMenu: mainMenu
                )
            }
        }
    }

    @available(iOS 27.1, *)
    @ViewBuilder
    private func foldAwareModal<Content: View>(
        in geometry: GeometryProxy,
        fold: ReservedRegion,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if fold.frame.height > fold.frame.width {
            content()
                .frame(width: fold.frame.minX, height: geometry.size.height)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        } else {
            content()
                .frame(
                    width: geometry.size.width,
                    height: max(0, geometry.size.height - fold.frame.maxY)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
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
                    if #available(iOS 27.1, *), let fold = geometry.dividingReservedRegion {
                        let regionIsLandscape = fold.frame.width > fold.frame.height
                        foldAwareModal(in: geometry, fold: fold) {
                            dungeonBeatModal(isLandscape: regionIsLandscape)
                        }
                        .transition(.opacityAndMoveFromBottom)
                    } else {
                        dungeonBeatModal(isLandscape: isLandscape)
                        .transition(.opacityAndMoveFromBottom)
                    }
                case .GameOver:
                    if #available(iOS 27.1, *), let fold = geometry.dividingReservedRegion {
                        let regionIsLandscape = fold.frame.width > fold.frame.height
                        foldAwareModal(in: geometry, fold: fold) {
                            gameOverModal(isLandscape: regionIsLandscape)
                        }
                        .transition(.opacityAndMoveFromBottom)
                    } else {
                        gameOverModal(isLandscape: isLandscape)
                        .transition(.opacityAndMoveFromBottom)
                    }
                case .Paused:
                    if #available(iOS 27.1, *), let fold = geometry.dividingReservedRegion {
                        foldAwareModal(in: geometry, fold: fold) {
                            pauseModal
                        }
                            .transition(.opacityAndMoveFromBottom)
                    } else {
                        pauseModal
                            .transition(.opacityAndMoveFromBottom)
                    }
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

//
//  ModalOverlayView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/15/25.
//

import SwiftUI

struct ModalOverlayView: View {
    @ObservedObject var game: Game
    @Binding var pauseMenuShown: Bool
    var nextDungeon: () -> Void
    var newGame: () -> Void
    var mainMenu: () -> Void
    
    var body: some View {
        ZStack {
            if game.gameOver || pauseMenuShown || game.dungeonBeat {
                Rectangle()
                    .ignoresSafeArea(.all)
                    .foregroundStyle(.ultraThinMaterial)
                    .opacity(0.7)
            }
            
            if game.dungeonBeat {
                DungeonBeatModalView(
                    game: game,
                    nextDungeon: nextDungeon
                )
                .transition(.opacityAndMoveFromBottom)
            }
            
            if game.gameOver {
                GameOverModalView(
                    game: game,
                    newGame: newGame,
                    mainMenu: mainMenu
                )
                .transition(.opacityAndMoveFromBottom)
            }
            
            if pauseMenuShown {
                PauseModalView(
                    continueGame: { withAnimation { pauseMenuShown = false } },
                    newGame: newGame,
                    mainMenu: mainMenu
                )
                .transition(.opacityAndMoveFromBottom)
            }
        }
    }
}

#Preview {
    struct ModalOverlayView_Preview: View {
        @State var pauseMenuShown: Bool = true
        
        var body: some View {
            ModalOverlayView(
                game: Game(),
                pauseMenuShown: $pauseMenuShown,
                nextDungeon: { },
                newGame: { },
                mainMenu: { }
            )
        }
    }
    
    return ModalOverlayView_Preview()
}

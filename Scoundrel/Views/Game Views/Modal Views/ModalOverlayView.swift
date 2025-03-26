//
//  ModalOverlayView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/15/25.
//

import SwiftUI

struct ModalOverlayView: View {
    @ObservedObject var game: Game
    //@Binding var pauseMenuShown: Bool
    var resumeGame: () -> Void
    var nextDungeon: () -> Void
    var newGame: () -> Void
    var mainMenu: () -> Void
    
    var body: some View {
        ZStack {
            if game.gameState == .GameOver || game.gameState == .Paused || game.gameState == .DungeonBeat {
                Rectangle()
                    .ignoresSafeArea(.all)
                    .foregroundStyle(.ultraThinMaterial)
                    .opacity(0.7)
            }
            
            switch game.gameState {
            case .DungeonBeat:
                DungeonBeatModalView(
                    game: game,
                    nextDungeon: nextDungeon
                )
                .transition(.opacityAndMoveFromBottom)
            case .GameOver:
                GameOverModalView(
                    game: game,
                    newGame: newGame,
                    mainMenu: mainMenu
                )
                .transition(.opacityAndMoveFromBottom)
            case .Paused:
                PauseModalView(
                    continueGame: resumeGame,
                    newGame: newGame,
                    mainMenu: mainMenu
                )
                .transition(.opacityAndMoveFromBottom)
            default:
                EmptyView()
            }
            
//            if game.gameState == .DungeonBeat {
//                DungeonBeatModalView(
//                    game: game,
//                    nextDungeon: nextDungeon
//                )
//                .transition(.opacityAndMoveFromBottom)
//            }
//            
//            if game.gameState == .GameOver {
//                GameOverModalView(
//                    game: game,
//                    newGame: newGame,
//                    mainMenu: mainMenu
//                )
//                .transition(.opacityAndMoveFromBottom)
//            }
//            
//            if game.gameState == .Paused {
//                PauseModalView(
//                    continueGame: resumeGame,
//                    newGame: newGame,
//                    mainMenu: mainMenu
//                )
//                .transition(.opacityAndMoveFromBottom)
//            }
        }
    }
}

#Preview {
    struct ModalOverlayView_Preview: View {
        //@State var pauseMenuShown: Bool = true
        
        var body: some View {
            ModalOverlayView(
                game: Game(),
                //pauseMenuShown: $pauseMenuShown,
                resumeGame: { },
                nextDungeon: { },
                newGame: { },
                mainMenu: { }
            )
        }
    }
    
    return ModalOverlayView_Preview()
}

//
//  GameView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import SwiftData
import AVFoundation

struct GameView: View {
    @Namespace var animation
    @ObservedObject var game: Game
    var mainMenu: () -> Void
    
    @State var pauseMenuShown: Bool = false
    @State var selectedCardIndex: Int?
    
    @State var background: String = "dungeon1"
    let backgrounds: [String] = [
        "dungeon1",
        "dungeon2",
        "dungeon3",
        "dungeon4",
        "dungeon5",
        "dungeon6",
        "dungeon7",
        "dungeon8",
        "dungeon9",
        "dungeon10"
    ]

    @State var pageSound: AVAudioPlayer?
    func initializeSounds() {
        do {
            pageSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page.mp3", ofType:nil)!))
            pageSound?.setVolume(3, fadeDuration: .zero)
        } catch {
            // couldn't load file :(
        }
    }
    
    func newGame() {
        selectedCardIndex = nil
        withAnimation { pauseMenuShown = false }
        background = backgrounds.randomElement()!
        game.newGame()
    }
    
    func actionSelected(cardIndex: Int, firstAction: Bool) {
        switch game.room.cards[cardIndex]!.suit {
        case .healthPotion:
            game.useHealthPotion(cardIndex: cardIndex)
            break
        case .weapon:
            game.equipWeapon(cardIndex: cardIndex)
            break
        case .monster:
            game.attackMonster(cardIndex: cardIndex, attackUnarmed: firstAction)
            break
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                TopBarView(
                    game: game,
                    pause: {
                        withAnimation { pauseMenuShown = true }
                        pageSound?.play()
                    },
                    animationNamespace: animation,
                    selectedCardIndex: $selectedCardIndex
                )
                
                Spacer()
                
                RoomView(
                    animationNamespace: animation,
                    room: game.room,
                    player: game.player,
                    actionSelected: actionSelected,
                    cardSelected: $selectedCardIndex
                )
                
                Spacer()
                
                StatsBarView(
                    player: game.player,
                    room: game.room,
                    animationNamespace: animation
                )
            }
            
            if game.gameOver || pauseMenuShown {
                Rectangle()
                    .ignoresSafeArea(.all)
                    .foregroundStyle(.ultraThinMaterial)
                    .opacity(0.7)
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
                    mainMenu: mainMenu,
                    room: game.room
                )
                .transition(.opacityAndMoveFromBottom)
            }
        }
        .background(Image(background))
        .onAppear() {
            game.gameKitHelper.hideAccessPoint()
            initializeSounds()
        }
    }
}

#Preview {
    struct GameView_Preview: View {
        var body: some View {
            GameView(
                game: Game(),
                mainMenu: {}
            )
        }
    }
    
    return GameView_Preview()
}

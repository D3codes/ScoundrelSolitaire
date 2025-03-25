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
    let ubiquitousHelper: UbiquitousHelper = UbiquitousHelper()
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    
    @Namespace var animation
    @ObservedObject var game: Game
    var mainMenu: () -> Void
    var randomBackground: () -> Void
    
    @State var pauseMenuShown: Bool = false
    @State var selectedCardIndex: Int?

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
        ubiquitousHelper.incrementGameCountAndRecalculateAverageScore(newScore: game.score, gameAbandoned: !game.gameOver)
        selectedCardIndex = nil
        withAnimation { pauseMenuShown = false }
        randomBackground()
        game.newGame()
    }
    
    func nextDungeon() {
        selectedCardIndex = nil
        randomBackground()
        game.nextDungeon()
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
                        if !soundEffectsMuted { pageSound?.play() }
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
            
            ModalOverlayView(
                game: game,
                pauseMenuShown: $pauseMenuShown,
                nextDungeon: nextDungeon,
                newGame: newGame,
                mainMenu: mainMenu
            )
        }
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
                mainMenu: {},
                randomBackground: {}
            )
        }
    }
    
    return GameView_Preview()
}

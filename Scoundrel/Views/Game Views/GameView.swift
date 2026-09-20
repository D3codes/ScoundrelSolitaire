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
    @AppStorage(UserDefaultsKeys().quickPlayEnabled) private var quickPlayEnabled: Bool = false
    
    @Namespace var animation
    @ObservedObject var game: Game
    var mainMenu: () -> Void
    var randomBackground: () -> Void
    
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
        ubiquitousHelper.incrementGameCountAndRecalculateAverageAndHighScores(newScore: game.score, gameAbandoned: game.player.health > 0)
        selectedCardIndex = nil
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
    
    func closeSelectedView() {
        withAnimation { selectedCardIndex = nil }
    }
    
    func firstActionTapped() {
        if selectedCardIndex == nil { return }
        let selectedCard: Int = selectedCardIndex!
        closeSelectedView()
        actionSelected(cardIndex: selectedCard, firstAction: true)
    }
    
    func secondActionTapped() {
        if selectedCardIndex == nil { return }
        let selectedCard: Int = selectedCardIndex!
        closeSelectedView()
        actionSelected(cardIndex: selectedCard, firstAction: false)
    }
    
    var body: some View {
        ZStack {
            VStack {
                TopBarView(
                    game: game,
                    pause: {
                        withAnimation { game.gameState = .Paused }
                        if !soundEffectsMuted { pageSound?.play() }
                    },
                    animationNamespace: animation,
                    selectedCardIndex: $selectedCardIndex
                )
                
                Spacer()
                
                RoomView(
                    animationNamespace: animation,
                    room: game.room,
                    cardSelected: $selectedCardIndex
                )
                
                Spacer()
                
                StatsBarView(
                    player: game.player,
                    room: game.room,
                    animationNamespace: animation
                )
            }
            
            if selectedCardIndex != nil {
                if quickPlayEnabled && ((game.room.cards[selectedCardIndex!]?.getSecondButtonText() ?? "").isEmpty || !game.player.canAttackWithWeapon(monsterStrength: game.room.cards[selectedCardIndex!]!.strength)) {
                    Circle().opacity(0).onAppear { firstActionTapped() }
                } else {
                    SelectedCardView(
                        cardSelected: $selectedCardIndex,
                        room: game.room,
                        player: game.player,
                        animationNamespace: animation,
                        cancel: closeSelectedView,
                        firstAction: firstActionTapped,
                        secondAction: secondActionTapped
                    )
                }
            }
            
            ModalOverlayView(
                game: game,
                resumeGame: { withAnimation { game.gameState = .Playing } },
                nextDungeon: nextDungeon,
                newGame: newGame,
                mainMenu: mainMenu
            )
        }
        .onAppear() {
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

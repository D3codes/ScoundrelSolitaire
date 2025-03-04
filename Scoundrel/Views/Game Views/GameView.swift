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
    @ObservedObject var gameKitHelper: GameKitHelper
    
    @ObservedObject var deck: Deck
    @ObservedObject var player: Player
    @ObservedObject var room: Room
    
    @State var gameOver: Bool = false
    @State var showAttackOptionAlert: Bool = false
    @State var pauseMenuShown: Bool = false
    
    @State var selectedCardIndex: Int?
    
    var startGame: () -> Void
    var mainMenu: () -> Void
    
    @State var pageSound: AVAudioPlayer?
    
    func initializeSounds() {
        do {
            pageSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page.mp3", ofType:nil)!))
            pageSound?.setVolume(3, fadeDuration: .zero)
        } catch {
            // couldn't load file :(
        }
    }

    func cardTapped(_ index: Int, attackWithFist: Bool) {
        room.canFlee = false
        
        switch room.cards[index]!.suit {
        case .weapon:
            player.equipWeapon(weaponStrength: room.cards[index]!.strength)
            endAction(index)
            break
        case .healthPotion:
            if !room.usedHealthPotion {
                player.useHealthPotion(potionStrength: room.cards[index]!.strength)
                room.usedHealthPotion = true
            }
            endAction(index)
            break
        case .monster:
            // Check for achievements pre-attack
            if !attackWithFist && player.lastAttacked ?? 0 == 15 && room.cards[index]!.strength == 2 {
                Task { await gameKitHelper.unlockAchievement(.WhatAWaste) }
            }
            
            // Attack
            if attackWithFist {
                player.attack(monsterStrength: room.cards[index]!.strength)
            } else {
                player.attack(withWeapon: true, monsterStrength: room.cards[index]!.strength)
            }
            
            // Check for achievements post-attack
            if player.health > 0 {
                if player.weapon ?? 0 == 2 && room.cards[index]!.strength == 14 {
                    Task { await gameKitHelper.unlockAchievement(.DavidAndGoliath) }
                }
            } else {
                if room.cards[index]!.strength == 2 {
                    Task { await gameKitHelper.unlockAchievement(.DefinitelyMeantToDoThat) }
                }
            }
            endAction(index)
            break
        }
    }
    
    func endAction(_ index: Int) {
        if player.health <= 0 {
            withAnimation { gameOver = true }
            return
        }
        
        withAnimation(.spring()) {
            room.removeCard(at: index)
        }
        
        if room.cards.filter({ $0 == nil }).count == 3 && !deck.cards.isEmpty {
            room.lockCardSelection = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                room.nextRoom(deck: deck, fleedLastRoom: false)
            }
        }
        
        if deck.cards.isEmpty && room.cards.filter({ $0 == nil }).count == 4 {
            if !room.playerFleed {
                Task { await gameKitHelper.unlockAchievement(.CowardsNeedNotApply) }
            }
            
            withAnimation { gameOver = true }
        }
    }
    
    func getScore() -> Int {
        if player.health > 0 {
            if player.health < 20 {
                return player.health
            }
            
            return room.cards.reduce(player.health) { $0 + (($1 != nil && $1!.suit == .healthPotion) ? $1!.strength : 0) }
        }
        
        return room.cards.reduce(deck.getScore()) { $0 - (($1 != nil && $1!.suit == .monster) ? $1!.strength : 0)}
    }
    
    func newGame() {
        selectedCardIndex = nil
        
        withAnimation(.spring()) {
            for i in 0...3 {
                withAnimation(.spring()) {
                    room.cards[i] = nil
                }
            }
        }
        
        startGame()
        withAnimation { gameOver = false }
        withAnimation { pauseMenuShown = false }
    }
    
    var body: some View {
        ZStack {
            VStack {
                TopBarView(
                    room: room,
                    deck: deck,
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
                    room: room,
                    player: player,
                    cardTapped: cardTapped,
                    cardSelected: $selectedCardIndex
                )
                
                Spacer()
                
                StatsBarView(
                    player: player,
                    room: room,
                    animationNamespace: animation
                )
            }
            
            if gameOver || pauseMenuShown {
                Rectangle()
                    .ignoresSafeArea(.all)
                    .foregroundStyle(.ultraThinMaterial)
                    .opacity(0.7)
            }
            
            if gameOver {
                GameOverModalView(
                    gameKitHelper: gameKitHelper,
                    score: getScore(),
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
        .onAppear() {
            gameKitHelper.hideAccessPoint()
            initializeSounds()
        }
    }
}

#Preview {
    struct GameView_Preview: View {
        @StateObject var deck: Deck = Deck()
        @StateObject var player: Player = Player()
        @StateObject var room = Room(
            cards: [
                Card(suit: .monster, strength: 5),
                Card(suit: .weapon, strength: 8),
                Card(suit: .healthPotion, strength: 3),
                nil
            ],
            fleedLastRoom: false
        )
        
        func startGame() { }
        func mainMenu() { }
        
        @StateObject var gameKitHelper = GameKitHelper()
        
        var body: some View {
            GameView(
                gameKitHelper: gameKitHelper,
                deck: deck,
                player: player,
                room: room,
                startGame: startGame,
                mainMenu: mainMenu
            )
        }
    }
    
    return GameView_Preview()
}

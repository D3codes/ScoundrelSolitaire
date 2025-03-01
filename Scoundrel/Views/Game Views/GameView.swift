//
//  GameView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Namespace var animation
    
    @ObservedObject var deck: Deck
    @ObservedObject var player: Player
    @ObservedObject var room: Room
    
    @State var gameOver: Bool = false
    @State var showAttackOptionAlert: Bool = false
    @State var pauseMenuShown: Bool = false
    
    @State var selectedCardIndex: Int?
    
    var startGame: () -> Void
    var mainMenu: () -> Void

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
            if attackWithFist {
                player.attack(monsterStrength: room.cards[index]!.strength)
            } else {
                player.attack(withWeapon: true, monsterStrength: room.cards[index]!.strength)
            }
            endAction(index)
            break
        }
    }
    
    func endAction(_ index: Int) {
        if player.health <= 0 || (deck.cards.isEmpty && room.cards.isEmpty) {
            gameOver = true
            return
        }
        
        withAnimation(.spring()) {
            room.removeCard(at: index)
        }
        
        if room.cards.filter({ $0 == nil }).count == 3 {
            room.nextRoom(deck: deck, fleedLastRoom: false)
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
        withAnimation(.spring()) {
            for i in 0...3 {
                withAnimation(.spring()) {
                    room.cards[i] = nil
                }
            }
        }
        
        startGame()
        gameOver = false
        pauseMenuShown = false
    }
    
    var body: some View {
        ZStack {
            VStack {
                TopBarView(
                    room: room,
                    deck: deck,
                    pause: { pauseMenuShown = true },
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
                
                PlayerView(player: player)
            }
            
            if gameOver {
                GameOverModalView(
                    score: getScore(),
                    newGame: newGame,
                    mainMenu: mainMenu
                )
            }
            
            if pauseMenuShown {
                PauseModalView(
                    continueGame: { pauseMenuShown = false },
                    newGame: newGame,
                    mainMenu: mainMenu
                )
            }
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
        
        var body: some View {
            GameView(
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

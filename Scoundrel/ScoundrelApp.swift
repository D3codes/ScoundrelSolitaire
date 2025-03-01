//
//  ScoundrelApp.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import SwiftData

@main
struct ScoundrelApp: App {
    
    @StateObject var musicPlayer: MusicPlayer = MusicPlayer()
    
    enum GameState: String, CaseIterable {
        case mainMenu
        case game
    }
    
    @State var gameState: GameState = .mainMenu
    
    @StateObject var deck: Deck = Deck()
    @StateObject var player: Player = Player()
    @StateObject var room = Room(cards: [nil, nil, nil, nil], fleedLastRoom: false)
    @State var dungeon: String = "dungeon1"
    
    let dungeons: [String] = [
        "dungeon1",
        "dungeon2",
        "dungeon3",
        "dungeon4",
        "dungeon5",
        "dungeon6",
        "dungeon7"
    ]
    
    func startGame() {
        player.reset()
        deck.reset()
        room.reset(
            cards: [deck.cards.remove(at: 0), deck.cards.remove(at: 0), deck.cards.remove(at: 0), deck.cards.remove(at: 0)],
            fleedLastRoom: false
        )
        dungeon = dungeons.randomElement()!
        
        gameState = .game
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch gameState {
                case .mainMenu:
                    MainMenuView(
                        musicPlayer: musicPlayer,
                        startGame: startGame
                    )
                case .game:
                    GameView(
                        deck: deck,
                        player: player,
                        room: room,
                        startGame: startGame,
                        mainMenu: { gameState = .mainMenu }
                    )
                }
            }
            .background(Image(dungeon))
            .onAppear {
                dungeon = dungeons.randomElement()!
                musicPlayer.isPlaying = true
            }
        }
    }
}

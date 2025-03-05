//
//  ScoundrelApp.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import SwiftData
import GameKit

@main
struct ScoundrelApp: App {
    @StateObject var musicPlayer: MusicPlayer = MusicPlayer()
    @StateObject var gameKitHelper: GameKitHelper = GameKitHelper()
    
    enum GameState: String, CaseIterable {
        case mainMenu
        case game
    }
    
    @State var gameState: GameState = .mainMenu
    
    @StateObject var deck: Deck = Deck()
    @StateObject var player: Player = Player()
    @StateObject var room = Room(cards: [nil, nil, nil, nil], fleedLastRoom: false)
    @State var background: String = "dungeon1"
    
    let backgrounds: [String] = [
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
        room.reset(deck: deck)
        background = backgrounds.randomElement()!
        
        gameState = .game
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch gameState {
                case .mainMenu:
                    MainMenuView(
                        musicPlayer: musicPlayer,
                        gameKitHelper: gameKitHelper,
                        startGame: startGame
                    )
                    .onAppear { gameKitHelper.showAccessPoint() }
                case .game:
                    GameView(
                        gameKitHelper: gameKitHelper,
                        deck: deck,
                        player: player,
                        room: room,
                        startGame: startGame,
                        mainMenu: { gameState = .mainMenu }
                    )
                    .onAppear {
                        gameKitHelper.hideAccessPoint()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            gameKitHelper.hideAccessPoint()
                        }
                    }
                }
            }
            .background(Image(background))
            .onAppear {
                musicPlayer.isPlaying = true
                gameKitHelper.authenticateLocalPlayer()
            }
        }
    }
}

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
        room.reset(deck: deck)
        dungeon = dungeons.randomElement()!
        
        gameState = .game
    }
    
    func initializeGameKit() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Present the view controller so the player can sign in.
                return
            }
            if error != nil {
                // Player could not be authenticated.
                // Disable Game Center in the game.
                return
            }
            
            // Player was successfully authenticated.
            // Check if there are any player restrictions before starting the game.
            gameKitHelper.localPlayerIsAuthenticated = true
                    
            if GKLocalPlayer.local.isUnderage {
                // Hide explicit game content.
            }


            if GKLocalPlayer.local.isMultiplayerGamingRestricted {
                // Disable multiplayer game features.
            }


            if GKLocalPlayer.local.isPersonalizedCommunicationRestricted {
                // Disable in game communication UI.
            }
            
            // Perform any other configurations as needed (for example, access point).
        }
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
                case .game:
                    GameView(
                        gameKitHelper: gameKitHelper,
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
                initializeGameKit()
            }
        }
    }
}

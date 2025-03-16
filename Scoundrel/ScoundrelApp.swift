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
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(UserDefaultsKeys().backgroundMusicMuted) private var backgroundMusicMuted: Bool = false
    
    @StateObject var musicPlayer: MusicPlayer = MusicPlayer()
    @StateObject var game: Game = Game()
    
    @State var gameState: GameState = .mainMenu
    enum GameState: String, CaseIterable, Codable {
        case mainMenu
        case game
    }
    
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
    
    func startGame() {
        game.newGame()
        gameState = .game
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch gameState {
                case .mainMenu:
                    MainMenuView(
                        musicPlayer: musicPlayer,
                        gameKitHelper: game.gameKitHelper,
                        game: game,
                        startGame: startGame,
                        resumeGame: { gameState = .game }
                    )
                    .onAppear { game.gameKitHelper.showAccessPoint() }
                case .game:
                    GameView(
                        game: game,
                        mainMenu: { gameState = .mainMenu },
                        randomBackground: { background = backgrounds.randomElement()! }
                    )
                    .onAppear {
                        game.gameKitHelper.hideAccessPoint()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            game.gameKitHelper.hideAccessPoint()
                        }
                    }
                }
            }
            .background(Image(background).resizable())
            .onAppear {
                musicPlayer.isPlaying = !backgroundMusicMuted
                game.gameKitHelper.authenticateLocalPlayer()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background || phase == .inactive {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(game) {
                    UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys().game)
                }
            }
        }
    }
}

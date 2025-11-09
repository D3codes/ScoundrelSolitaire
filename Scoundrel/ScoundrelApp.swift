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
    let ubiquitousHelper: UbiquitousHelper = UbiquitousHelper()
    
    @StateObject var musicPlayer: MusicPlayer = MusicPlayer()
    @StateObject var game: Game = Game()
    
    @State var appState: AppState = .MainMenu
    enum AppState: String, CaseIterable, Codable {
        case MainMenu
        case Game
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
        if game.gameState != .GameOver && game.gameState != .Created {
            ubiquitousHelper.incrementGameCountAndRecalculateAverageAndHighScores(newScore: game.score, gameAbandoned: true)
        }
        
        game.newGame()
        appState = .Game
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState {
                case .MainMenu:
                    MainMenuView(
                        musicPlayer: musicPlayer,
                        gameKitHelper: game.gameKitHelper,
                        game: game,
                        startGame: startGame,
                        resumeGame: {
                            game.gameState = .Playing
                            appState = .Game
                        }
                    )
                    .onAppear { game.gameKitHelper.showAccessPoint() }
                case .Game:
                    GameView(
                        game: game,
                        mainMenu: { appState = .MainMenu },
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
            .frame(minHeight: 600)
            .background(Image(background).resizable())
            .onAppear {
                musicPlayer.isPlaying = !backgroundMusicMuted
                game.gameKitHelper.authenticateLocalPlayer()
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background || newValue == .inactive {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(game) {
                    UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys().game)
                }
            }
        }
        .windowResizability(.contentSize)
    }
}

//
//  MainMenuView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import AVFoundation

struct MainMenuView: View {
    private enum ControllerSelection: CaseIterable {
        case settings
        case leaderboard
        case resume
        case newGame
        case howToPlay
        case stats
    }

    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var gameKitHelper: GameKitHelper
    @ObservedObject var game: Game
    @EnvironmentObject private var controllerInput: ControllerInputMonitor
    
    var startGame: () -> Void
    var resumeGame: () -> Void
    
    @State var showHowToModal: Bool = false
    @State var showStatsModal: Bool = false
    @State private var showSettingsModal = false
    @State private var showLeaderboardModal = false
    @State private var isLandscape = false
    
    @State var page2Sound: AVAudioPlayer?
    @State private var controllerSelection: ControllerSelection = .newGame
    @FocusState private var receivesKeyboardInput: Bool

    private var availableControllerSelections: [ControllerSelection] {
        var selections: [ControllerSelection] = [.settings]
        if gameKitHelper.localPlayerIsAuthenticated {
            selections.append(.leaderboard)
        }
        if game.gameState != .GameOver && game.gameState != .Created {
            selections.append(.resume)
        }
        selections.append(contentsOf: [.newGame, .howToPlay, .stats])
        return selections
    }

    private var firstContentSelection: ControllerSelection {
        game.gameState != .GameOver && game.gameState != .Created ? .resume : .newGame
    }

    private func isControllerFocused(_ selection: ControllerSelection) -> Bool {
        controllerInput.isControllerConnected && controllerSelection == selection
    }
    
    func initializeSounds() {
        do {
            page2Sound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page2.mp3", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }
    }

    private func handleControllerInput(_ input: ControllerInput) {
        let selections = availableControllerSelections
        guard !selections.isEmpty else { return }

        if !selections.contains(controllerSelection) {
            controllerSelection = selections[0]
        }

        switch input {
        case .up, .down, .left, .right:
            moveControllerSelection(input)
        case .primary:
            switch controllerSelection {
            case .settings:
                showSettingsModal = true
                if !soundEffectsMuted { page2Sound?.play() }
            case .leaderboard:
                guard gameKitHelper.localPlayerIsAuthenticated else { return }
                showLeaderboardModal = true
                if !soundEffectsMuted { page2Sound?.play() }
            case .resume:
                resumeGame()
            case .newGame:
                startGame()
            case .howToPlay:
                showHowToModal = true
                if !soundEffectsMuted { page2Sound?.play() }
            case .stats:
                showStatsModal = true
                if !soundEffectsMuted { page2Sound?.play() }
            }
        case .secondary:
            break
        case .menu:
            showSettingsModal = true
            if !soundEffectsMuted { page2Sound?.play() }
        }
    }

    private func moveControllerSelection(_ input: ControllerInput) {
        let hasResume = game.gameState != .GameOver && game.gameState != .Created

        if isLandscape {
            switch (controllerSelection, input) {
            case (.settings, .right): controllerSelection = gameKitHelper.localPlayerIsAuthenticated ? .leaderboard : .settings
            case (.settings, .down): controllerSelection = .newGame
            case (.leaderboard, .left): controllerSelection = .settings
            case (.leaderboard, .down): controllerSelection = hasResume ? .resume : .newGame
            case (.newGame, .up): controllerSelection = .settings
            case (.newGame, .down): controllerSelection = .howToPlay
            case (.newGame, .right), (.howToPlay, .right), (.stats, .right):
                if hasResume { controllerSelection = .resume }
            case (.howToPlay, .up): controllerSelection = .newGame
            case (.howToPlay, .down): controllerSelection = .stats
            case (.stats, .up): controllerSelection = .howToPlay
            case (.resume, .left): controllerSelection = .newGame
            case (.resume, .up): controllerSelection = gameKitHelper.localPlayerIsAuthenticated ? .leaderboard : .settings
            case (.resume, .down): controllerSelection = .newGame
            default: break
            }
        } else {
            switch (controllerSelection, input) {
            case (.settings, .right): controllerSelection = gameKitHelper.localPlayerIsAuthenticated ? .leaderboard : .settings
            case (.settings, .down), (.leaderboard, .down): controllerSelection = firstContentSelection
            case (.leaderboard, .left): controllerSelection = .settings
            case (.resume, .up): controllerSelection = .settings
            case (.resume, .down): controllerSelection = .newGame
            case (.newGame, .up): controllerSelection = hasResume ? .resume : .settings
            case (.newGame, .down): controllerSelection = .howToPlay
            case (.howToPlay, .up): controllerSelection = .newGame
            case (.howToPlay, .down): controllerSelection = .stats
            case (.stats, .up): controllerSelection = .howToPlay
            case (.stats, .down): controllerSelection = .settings
            default: break
            }
        }
    }

    private func handleKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        let input: ControllerInput
        switch keyPress.key {
        case .upArrow: input = .up
        case .downArrow: input = .down
        case .leftArrow: input = .left
        case .rightArrow: input = .right
        case .return, .space: input = .primary
        case .escape: input = .secondary
        default: return .ignored
        }
        handleControllerInput(input)
        return .handled
    }
    
    
    
    var body: some View {
        ZStack {
            VStack {
                ControlBarView(
                    musicPlayer: musicPlayer,
                    gameKitHelper: gameKitHelper,
                    settingsIsControllerFocused: isControllerFocused(.settings),
                    leaderboardIsControllerFocused: isControllerFocused(.leaderboard),
                    showSettings: { showSettingsModal = true },
                    showLeaderboard: { showLeaderboardModal = true }
                )
                
                Spacer()
                
                ViewThatFits {
                    VStack {
                        if game.gameState != .GameOver && game.gameState != .Created {
                            ResumeButtonView(
                                game: game,
                                resumeGame: resumeGame,
                                isControllerFocused: isControllerFocused(.resume)
                            )
                        }
                        
                        PlankButtonView(
                            text: "New Game",
                            isControllerFocused: isControllerFocused(.newGame),
                            action: startGame
                        )
                            .padding(.bottom, 40)
                        
                        PlankButtonView(text: "How to Play", isControllerFocused: isControllerFocused(.howToPlay), action: {
                            showHowToModal = true
                            if !soundEffectsMuted { page2Sound?.play() }
                        })
                        
                        PlankButtonView(text: "Stats", isControllerFocused: isControllerFocused(.stats), action: {
                            showStatsModal = true
                            if !soundEffectsMuted { page2Sound?.play() }
                        })
                    }
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            PlankButtonView(text: "New Game", isControllerFocused: isControllerFocused(.newGame), action: startGame)
                                    .padding(.bottom, 40)
                            
                            PlankButtonView(text: "How to Play", isControllerFocused: isControllerFocused(.howToPlay), action: {
                                showHowToModal = true
                                if !soundEffectsMuted { page2Sound?.play() }
                            })
                            
                            PlankButtonView(text: "Stats", isControllerFocused: isControllerFocused(.stats), action: {
                                showStatsModal = true
                                if !soundEffectsMuted { page2Sound?.play() }
                            })
                        }
    
                        if game.gameState != .GameOver && game.gameState != .Created {
                            Spacer()
                            ResumeButtonView(
                                game: game,
                                resumeGame: resumeGame,
                                isControllerFocused: isControllerFocused(.resume)
                            )
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .focusable()
        .focused($receivesKeyboardInput)
        .onKeyPress(phases: [.down, .repeat], action: handleKeyPress)
        .onGeometryChange(for: Bool.self) { proxy in
            proxy.size.width > proxy.size.height
        } action: { isLandscape in
            self.isLandscape = isLandscape
        }
        .sheet(isPresented: $showHowToModal) {
            HowToView()
                .onAppear { gameKitHelper.hideAccessPoint() }
                .onDisappear { gameKitHelper.showAccessPoint() }
        }
        .sheet(isPresented: $showStatsModal) {
            StatsView(gameKitHelper: game.gameKitHelper)
                .onAppear { gameKitHelper.hideAccessPoint() }
                .onDisappear { gameKitHelper.showAccessPoint() }
        }
        .sheet(isPresented: $showSettingsModal) {
            SettingsView(musicPlayer: musicPlayer)
                .onAppear { gameKitHelper.hideAccessPoint() }
                .onDisappear { gameKitHelper.showAccessPoint() }
        }
        .sheet(isPresented: $showLeaderboardModal) {
            LeaderboardView(gameKitHelper: gameKitHelper)
        }
        .onAppear {
            initializeSounds()
            receivesKeyboardInput = true
        }
        .onChange(of: controllerInput.occurrence) { _, occurrence in
            guard let occurrence else { return }
            if occurrence.input == .secondary {
                if showHowToModal { showHowToModal = false }
                if showStatsModal { showStatsModal = false }
                if showSettingsModal { showSettingsModal = false }
                if showLeaderboardModal { showLeaderboardModal = false }
                return
            }
            if occurrence.input == .menu {
                guard !showHowToModal, !showStatsModal, !showSettingsModal, !showLeaderboardModal else { return }
                handleControllerInput(.menu)
                return
            }
            guard !showHowToModal, !showStatsModal, !showSettingsModal, !showLeaderboardModal else { return }
            handleControllerInput(occurrence.input)
        }
        .onChange(of: showHowToModal) { _, isPresented in
            if !isPresented { receivesKeyboardInput = true }
        }
        .onChange(of: showStatsModal) { _, isPresented in
            if !isPresented { receivesKeyboardInput = true }
        }
    }
}

#Preview {
    struct MainMenuView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        @StateObject var gameKitHelper = GameKitHelper()
        
        var body: some View {
            MainMenuView(
                musicPlayer: musicPlayer,
                gameKitHelper: gameKitHelper,
                game: Game(),
                startGame: {},
                resumeGame: {}
            )
        }
    }
    
    return MainMenuView_Preview()
}

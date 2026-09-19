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
    private enum ControllerSelection: Hashable {
        case pause
        case card(Int)
        case flee
        case firstCardAction
        case secondCardAction
        case modalAction(Int)
    }

    let ubiquitousHelper: UbiquitousHelper = UbiquitousHelper()
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    
    @Namespace var animation
    @ObservedObject var game: Game
    @EnvironmentObject private var controllerInput: ControllerInputMonitor
    var mainMenu: () -> Void
    var randomBackground: () -> Void
    
    @State var selectedCardIndex: Int?
    @State private var controllerSelection: ControllerSelection = .card(0)
    @State private var lastFocusedCardIndex: Int?
    @State private var isLandscape = false
    @FocusState private var receivesKeyboardInput: Bool

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
        lastFocusedCardIndex = selectedCard
        closeSelectedView()
        actionSelected(cardIndex: selectedCard, firstAction: true)
        controllerSelection = nearestCardSelection(to: selectedCard)
            ?? availableControllerSelections.first
            ?? .pause
    }
    
    func secondActionTapped() {
        if selectedCardIndex == nil { return }
        let selectedCard: Int = selectedCardIndex!
        lastFocusedCardIndex = selectedCard
        closeSelectedView()
        actionSelected(cardIndex: selectedCard, firstAction: false)
        controllerSelection = nearestCardSelection(to: selectedCard)
            ?? availableControllerSelections.first
            ?? .pause
    }

    private var availableControllerSelections: [ControllerSelection] {
        if selectedCardIndex != nil {
            var selections: [ControllerSelection] = [.firstCardAction]
            if let selectedCardIndex,
               !(game.room.cards[selectedCardIndex]?.getSecondButtonText() ?? "").isEmpty,
               let strength = game.room.cards[selectedCardIndex]?.strength,
               game.player.canAttackWithWeapon(monsterStrength: strength) {
                selections.append(.secondCardAction)
            }
            return selections
        }

        switch game.gameState {
        case .Playing:
            var selections: [ControllerSelection] = []
            if !game.room.isDealingCards { selections.append(.pause) }
            selections.append(contentsOf: game.room.cards.indices.compactMap { index in
                game.room.cards[index] == nil || game.room.isDealingCards ? nil : .card(index)
            })
            if game.room.canFlee && !game.room.isDealingCards { selections.append(.flee) }
            return selections
        case .Paused:
            return [.modalAction(0), .modalAction(1), .modalAction(2)]
        case .DungeonBeat:
            return [.modalAction(0)]
        case .GameOver:
            return [.modalAction(0), .modalAction(1)]
        case .Created:
            return []
        }
    }

    private func isControllerFocused(_ selection: ControllerSelection) -> Bool {
        controllerInput.isControllerConnected && controllerSelection == selection
    }

    private func handleControllerInput(_ input: ControllerInput) {
        let selections = availableControllerSelections
        guard !selections.isEmpty else { return }

        if !selections.contains(controllerSelection) {
            controllerSelection = selections[0]
        }

        switch input {
        case .up, .down, .left, .right:
            moveControllerSelection(input, availableSelections: selections)
        case .primary:
            activateControllerSelection()
        case .secondary:
            if selectedCardIndex != nil {
                closeSelectedView()
            } else if game.gameState == .Paused {
                withAnimation { game.gameState = .Playing }
            }
        case .menu:
            guard game.gameState == .Playing else { return }
            selectedCardIndex = nil
            withAnimation { game.gameState = .Paused }
            controllerSelection = .modalAction(2)
        }
    }

    private func moveControllerSelection(
        _ input: ControllerInput,
        availableSelections: [ControllerSelection]
    ) {
        if selectedCardIndex != nil || game.gameState != .Playing {
            let index = availableSelections.firstIndex(of: controllerSelection) ?? 0
            let offset = input == .up || input == .left ? -1 : 1
            controllerSelection = availableSelections[(index + offset + availableSelections.count) % availableSelections.count]
            return
        }

        let candidates: [ControllerSelection]
        if isLandscape {
            switch (controllerSelection, input) {
            case (.pause, .right): candidates = [.flee]
            case (.pause, .down): candidates = [.card(0), .card(1), .card(2), .card(3)]
            case (.flee, .left): candidates = [.pause]
            case (.flee, .down): candidates = [.card(3), .card(2), .card(1), .card(0)]
            case (.card(let index), .left): candidates = (stride(from: index - 1, through: 0, by: -1).map(ControllerSelection.card)) + [.pause]
            case (.card(let index), .right): candidates = stride(from: index + 1, through: 3, by: 1).map(ControllerSelection.card) + [.flee]
            case (.card(let index), .up): candidates = index < 2 ? [.pause] : [.flee]
            default: candidates = []
            }
        } else {
            switch (controllerSelection, input) {
            case (.pause, .right): candidates = [.flee]
            case (.pause, .down): candidates = [.card(0), .card(1), .card(2), .card(3)]
            case (.flee, .left): candidates = [.pause]
            case (.flee, .down): candidates = [.card(1), .card(0), .card(3), .card(2)]
            case (.card(0), .right): candidates = [.card(1), .card(3)]
            case (.card(0), .down): candidates = [.card(2), .card(3)]
            case (.card(0), .up): candidates = [.pause]
            case (.card(1), .left): candidates = [.card(0), .card(2)]
            case (.card(1), .down): candidates = [.card(3), .card(2)]
            case (.card(1), .up): candidates = [.flee]
            case (.card(2), .right): candidates = [.card(3), .card(1)]
            case (.card(2), .up): candidates = [.card(0), .card(1)]
            case (.card(2), .down): candidates = [.pause]
            case (.card(3), .left): candidates = [.card(2), .card(0)]
            case (.card(3), .up): candidates = [.card(1), .card(0)]
            case (.card(3), .down): candidates = [.flee]
            default: candidates = []
            }
        }

        if let destination = candidates.first(where: availableSelections.contains) {
            controllerSelection = destination
        }
    }

    private func activateControllerSelection() {
        switch controllerSelection {
        case .pause:
            withAnimation { game.gameState = .Paused }
            if !soundEffectsMuted { pageSound?.play() }
        case .card(let index):
            guard game.room.cards[index] != nil, !game.room.isDealingCards else { return }
            lastFocusedCardIndex = index
            withAnimation { selectedCardIndex = index }
            controllerSelection = .firstCardAction
        case .flee:
            selectedCardIndex = nil
            game.flee()
        case .firstCardAction:
            firstActionTapped()
        case .secondCardAction:
            secondActionTapped()
        case .modalAction(let index):
            switch game.gameState {
            case .Paused:
                if index == 0 { mainMenu() }
                else if index == 1 { newGame() }
                else { withAnimation { game.gameState = .Playing } }
            case .DungeonBeat:
                nextDungeon()
            case .GameOver:
                if index == 0 { mainMenu() } else { newGame() }
            default:
                break
            }
        }
    }

    private func nearestCardSelection(to sourceIndex: Int?) -> ControllerSelection? {
        let availableIndices = game.room.cards.indices.filter { game.room.cards[$0] != nil }
        guard !availableIndices.isEmpty else { return nil }
        guard let sourceIndex else { return .card(availableIndices[0]) }

        let nearestIndex = availableIndices.min { first, second in
            cardDistance(from: sourceIndex, to: first) < cardDistance(from: sourceIndex, to: second)
        }
        return nearestIndex.map(ControllerSelection.card)
    }

    private func cardDistance(from source: Int, to destination: Int) -> Int {
        if isLandscape { return abs(source - destination) }
        let sourcePosition = (row: source / 2, column: source % 2)
        let destinationPosition = (row: destination / 2, column: destination % 2)
        return abs(sourcePosition.row - destinationPosition.row)
            + abs(sourcePosition.column - destinationPosition.column)
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
                TopBarView(
                    game: game,
                    pause: {
                        withAnimation { game.gameState = .Paused }
                        if !soundEffectsMuted { pageSound?.play() }
                    },
                    animationNamespace: animation,
                    selectedCardIndex: $selectedCardIndex,
                    pauseIsControllerFocused: isControllerFocused(.pause),
                    fleeIsControllerFocused: isControllerFocused(.flee)
                )
                
                Spacer()
                
                RoomView(
                    animationNamespace: animation,
                    room: game.room,
                    cardSelected: $selectedCardIndex,
                    controllerFocusedCardIndex: {
                        guard controllerInput.isControllerConnected else { return nil }
                        if case .card(let index) = controllerSelection { return index }
                        return nil
                    }()
                )
                
                Spacer()
                
                StatsBarView(
                    player: game.player,
                    room: game.room,
                    animationNamespace: animation
                )
            }
            .disabled(selectedCardIndex != nil || game.gameState != .Playing)
            
            if selectedCardIndex != nil {
                SelectedCardView(
                    cardSelected: $selectedCardIndex,
                    room: game.room,
                    player: game.player,
                    animationNamespace: animation,
                    cancel: closeSelectedView,
                    firstAction: firstActionTapped,
                    secondAction: secondActionTapped,
                    firstActionIsControllerFocused: isControllerFocused(.firstCardAction),
                    secondActionIsControllerFocused: isControllerFocused(.secondCardAction)
                )
            }
            
            ModalOverlayView(
                game: game,
                resumeGame: { withAnimation { game.gameState = .Playing } },
                nextDungeon: nextDungeon,
                newGame: newGame,
                mainMenu: mainMenu,
                controllerSelection: {
                    guard controllerInput.isControllerConnected else { return nil }
                    if case .modalAction(let index) = controllerSelection { return index }
                    return nil
                }()
            )
        }
        .focusable()
        .focused($receivesKeyboardInput)
        .onKeyPress(phases: [.down, .repeat], action: handleKeyPress)
        .onGeometryChange(for: Bool.self) { proxy in
            proxy.size.width > proxy.size.height
        } action: { isLandscape in
            self.isLandscape = isLandscape
        }
        .onAppear() {
            game.gameKitHelper.hideAccessPoint()
            initializeSounds()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                game.gameKitHelper.hideAccessPoint()
            }
            receivesKeyboardInput = true
            controllerSelection = availableControllerSelections.first ?? .pause
        }
        .onChange(of: controllerInput.occurrence) { _, occurrence in
            guard let occurrence else { return }
            handleControllerInput(occurrence.input)
        }
        .onChange(of: game.gameState) { _, _ in
            controllerSelection = availableControllerSelections.first ?? .pause
        }
        .onChange(of: selectedCardIndex) { _, selectedCardIndex in
            if let selectedCardIndex {
                lastFocusedCardIndex = selectedCardIndex
                controllerSelection = .firstCardAction
            } else {
                controllerSelection = nearestCardSelection(to: lastFocusedCardIndex)
                    ?? availableControllerSelections.first
                    ?? .pause
            }
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

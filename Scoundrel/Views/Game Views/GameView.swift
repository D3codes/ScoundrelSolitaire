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
    
    func closeSelectedView() {
        withAnimation { selectedCardIndex = nil }
    }
    
    func actionSelected(firstAction: Bool) {
        if selectedCardIndex == nil { return }
        let selectedCard: Int = selectedCardIndex!
        closeSelectedView()
        
        switch game.room.cards[selectedCard]!.suit {
        case .healthPotion:
            game.useHealthPotion(cardIndex: selectedCard)
            break
        case .weapon:
            game.equipWeapon(cardIndex: selectedCard)
            break
        case .monster:
            game.attackMonster(cardIndex: selectedCard, attackUnarmed: firstAction)
            break
        }
    }
    
    func canQuickPlaySelectedCard() -> Bool {
        return ((game.room.cards[selectedCardIndex!]?.getSecondButtonText() ?? "").isEmpty || !game.player.canAttackWithWeapon(monsterStrength: game.room.cards[selectedCardIndex!]!.strength))
    }

    private var gameLayout: some View {
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
    }

    @available(iOS 27.1, *)
    @ViewBuilder
    private func foldAwareGameLayout(in geometry: GeometryProxy, fold: ReservedRegion) -> some View {
        let isLandscape: Bool = fold.frame.height > fold.frame.width
        if isLandscape {
            VStack(spacing: 0) {
                TopBarView(
                    game: game,
                    pause: {
                        withAnimation { game.gameState = .Paused }
                        if !soundEffectsMuted { pageSound?.play() }
                    },
                    animationNamespace: animation,
                    selectedCardIndex: $selectedCardIndex
                )

                RoomView(
                    animationNamespace: animation,
                    room: game.room,
                    cardSelected: $selectedCardIndex
                )
                .frame(maxHeight: .infinity)

                StatsBarView(
                    player: game.player,
                    room: game.room,
                    animationNamespace: animation,
                    foldFrame: fold.frame
                )
                .frame(height: 80)
            }
        } else {
            gameLayout
                .frame(
                    width: geometry.size.width,
                    height: max(0, geometry.size.height - fold.frame.maxY)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if #available(iOS 27.1, *), let fold = geometry.dividingReservedRegion {
                    foldAwareGameLayout(in: geometry, fold: fold)
                } else {
                    gameLayout
                }
            }
            
            if selectedCardIndex != nil {
                if quickPlayEnabled && canQuickPlaySelectedCard() {
                    Circle().opacity(0).onAppear { actionSelected(firstAction: true) }
                } else {
                    SelectedCardView(
                        cardSelected: $selectedCardIndex,
                        room: game.room,
                        player: game.player,
                        animationNamespace: animation,
                        cancel: closeSelectedView,
                        firstAction: { actionSelected(firstAction: true) },
                        secondAction: { actionSelected(firstAction: false) }
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

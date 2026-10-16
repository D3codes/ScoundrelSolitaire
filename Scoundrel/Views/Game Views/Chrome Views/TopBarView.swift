//
//  TopBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/24/25.
//

import SwiftUI

struct TopBarView: View {
    @AppStorage(UserDefaultsKeys().hapticsEnabled) private var hapticsEnabled: Bool = true
    
    @ObservedObject var game: Game
    var pause: () -> Void
    var animationNamespace: Namespace.ID
    @Binding var selectedCardIndex: Int?
    
    @State var showingDeckCountPopover: Bool = false
    @State var showingDungeonCountPopover: Bool = false
    
    private var pauseButton: some View {
            Button(action: { pause() }, label: {
                ZStack {
                    Image("stoneButton")
                        .resizable()
                        .frame(width: 50, height: 50)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    Text("||")
                        .foregroundStyle(!game.room.isDealingCards ? .white : .black)
                        .font(.custom("MorrisRoman-Black", size: 30))
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                }
            })
            .disabled(game.room.isDealingCards)
            .blur(radius: !game.room.isDealingCards ? 0 : 0.5)
    }

    private var deckButton: some View {
            ZStack {
                ForEach(0..<4) { index in
                    if game.room.cards[index] == nil && game.room.destinations[index] == .deck {
                        Rectangle()
                            .opacity(0)
                            .frame(width: 50, height: 50)
                            .matchedGeometryEffect(
                                id: "Card\(index)",
                                in: animationNamespace,
                                properties: .position
                            )
                            .transition(.opacityAndScale)
                    }
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 50)
                    .glassEffect(in: .rect(cornerRadius: 10))
                    
                if hapticsEnabled {
                    VStack(spacing: 0) {
                        Image("deck")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(game.deck.cards.count)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                    .sensoryFeedback(.increase, trigger: game.deck.iconSize)
                } else {
                    VStack(spacing: 0) {
                        Image("deck")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(game.deck.cards.count)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
            }
            .scaleEffect(game.deck.iconSize)
            .animation(.spring(duration: 0.5, bounce: 0.6), value: game.deck.iconSize)
            .onTapGesture { showingDeckCountPopover = true }
            .popover(isPresented: $showingDeckCountPopover) {
                Text("\(game.deck.cards.count) cards left in deck")
                    .font(.headline)
                    .padding()
                    .presentationCompactAdaptation(.popover)
            }
    }

    private var scoreView: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .glassEffect(in: .rect(cornerRadius: 10))
                    
                VStack(spacing: 0) {
                    Text("Score")
                        .frame(height: 30)
                        .font(.custom("MorrisRoman-Black", size: 20))
                    Text("\(game.score)")
                        .font(.custom("MorrisRoman-Black", size: 20))
                        .contentTransition(.numericText())
                }
            }
            .frame(minWidth: 50, maxWidth: 200)
    }

    private var dungeonButton: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 50)
                    .glassEffect(in: .rect(cornerRadius: 10))
                    
                VStack(spacing: 0) {
                    Image("dungeonGlyph")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("\(game.dungeonDepth)")
                        .font(.custom("MorrisRoman-Black", size: 20))
                        .contentTransition(.numericText())
                }
            }
            .onTapGesture { showingDungeonCountPopover = true }
            .popover(isPresented: $showingDungeonCountPopover) {
                Text("\(game.dungeonDepth) dungeons beat")
                    .font(.headline)
                    .padding()
                    .presentationCompactAdaptation(.popover)
            }
    }

    private var fleeButton: some View {
            ZStack {
                Button(action: {
                    selectedCardIndex = nil
                    game.flee()
                }, label: {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 50, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        Image(systemName: "figure.run")
                            .foregroundStyle(game.room.canFlee && !game.room.isDealingCards ? .white : .black)
                            .font(.title2)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                })
                .disabled(!game.room.canFlee || game.room.isDealingCards)
                .blur(radius: game.room.canFlee && !game.room.isDealingCards ? 0 : 0.5)
                
                if(!game.room.canFlee || game.room.isDealingCards) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.ultraThinMaterial)
                        .opacity(0.5)
                }
            }
    }

    private func topBarLayout(addSpacer: Bool) -> some View {
        HStack {
            pauseButton
            deckButton
            if addSpacer {
                Spacer()
            }
            scoreView
            dungeonButton
            fleeButton
        }
        .padding(.horizontal)
        .padding(.trailing, addSpacer ? 40 : 0)
    }

    var body: some View {
        GeometryReader { geometry in
            if #available(iOS 27.1, *), let fold = geometry.dividingReservedRegion, fold.frame.height > fold.frame.width {
                topBarLayout(addSpacer: true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                topBarLayout(addSpacer: false)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
    }
}

#Preview {
    struct TopBarView_Preview: View {
        @Namespace var animation
        @State var selectedCardIndex: Int?
        @State var score: Int = 202
        
        var body: some View {
            TopBarView(
                game: Game(),
                pause: {},
                animationNamespace: animation,
                selectedCardIndex: $selectedCardIndex
            )
        }
    }
    
    return TopBarView_Preview()
}

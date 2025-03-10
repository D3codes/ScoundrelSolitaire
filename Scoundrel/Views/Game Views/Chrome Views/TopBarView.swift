//
//  TopBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/24/25.
//

import SwiftUI

struct TopBarView: View {
    @ObservedObject var game: Game
    var pause: () -> Void
    var animationNamespace: Namespace.ID
    @Binding var selectedCardIndex: Int?
    
    @State var showingDeckCountPopover: Bool = false
    
    var body: some View {
        HStack {
            Button(action: { pause() }, label: {
                ZStack {
                    Image("stoneButton")
                        .resizable()
                        .frame(width: 50, height: 50)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    Text("||")
                        .foregroundStyle(.white)
                        .font(.custom("MorrisRoman-Black", size: 30))
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                }
            })
            
            ZStack {
                ForEach(0..<4) { index in
                    if game.room.cards[index] == nil && game.room.destinations[index] == .deck {
                        Rectangle()
                            .opacity(0)
                            .frame(width: 50, height: 50)
                            .matchedGeometryEffect(id: "Card\(index)", in: animationNamespace)
                            .transition(.opacityAndScale)
                    }
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.regularMaterial)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                if #available(iOS 17.0, *) { // sensory feedback not available on older OS versions
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
            .onTapGesture {
                if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                    showingDeckCountPopover = true
                }
            }
            .popover(isPresented: $showingDeckCountPopover) {
                if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                    Text("\(game.deck.cards.count) cards left in deck")
                        .font(.headline)
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
            }
            .padding(.horizontal)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundStyle(.regularMaterial)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                VStack(spacing: 0) {
                    Text("Score")
                        .font(.custom("MorrisRoman-Black", size: 20))
                    Text("\(game.score)")
                        .font(.custom("MorrisRoman-Black", size: 20))
                        .contentTransition(.numericText())
                }
            }
            .padding(.trailing)
            
            ZStack {
                Button(action: {
                    selectedCardIndex = nil
                    game.flee()
                }, label: {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 100, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        Text("Flee")
                            .foregroundStyle(game.room.canFlee && !game.room.isDealingCards ? .white : .black)
                            .font(.custom("ModernAntiqua-Regular", size: 30))
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                })
                .disabled(!game.room.canFlee || game.room.isDealingCards)
                .blur(radius: game.room.canFlee && !game.room.isDealingCards ? 0 : 0.5)
                
                if(!game.room.canFlee || game.room.isDealingCards) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 100, height: 50)
                        .foregroundStyle(.ultraThinMaterial)
                        .opacity(0.5)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(
            Image("stoneSlab2")
                .resizable()
                .frame(width: 800)
                .ignoresSafeArea()
                .shadow(color: .black, radius: 15, x: 0, y: 5)
        )
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

//
//  TopBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/24/25.
//

import SwiftUI

struct TopBarView: View {
    @ObservedObject var room: Room
    @ObservedObject var deck: Deck
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
                    if room.cards[index] == nil && room.destinations[index] == .deck {
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
                        Text("\(deck.cards.count)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                    .sensoryFeedback(.increase, trigger: deck.iconSize)
                } else {
                    VStack(spacing: 0) {
                        Image("deck")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(deck.cards.count)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
            }
            .scaleEffect(deck.iconSize)
            .animation(.spring(duration: 0.5, bounce: 0.6), value: deck.iconSize)
            .onTapGesture {
                if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                    showingDeckCountPopover = true
                }
            }
            .popover(isPresented: $showingDeckCountPopover) {
                if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                    Text("\(deck.cards.count) cards left in deck")
                        .font(.headline)
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            ZStack {
                Button(action: {
                    selectedCardIndex = nil
                    room.flee(deck: deck)
                }, label: {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 100, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        Text("Flee")
                            .foregroundStyle(room.canFlee && !room.isDealingCards ? .white : .black)
                            .font(.custom("ModernAntiqua-Regular", size: 30))
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                })
                .disabled(!room.canFlee || room.isDealingCards)
                .blur(radius: room.canFlee && !room.isDealingCards ? 0 : 0.5)
                
                if(!room.canFlee || room.isDealingCards) {
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
        
        @StateObject var room: Room = Room(cards: [nil, nil, nil, nil], fleedLastRoom: false)
        @StateObject var deck: Deck = Deck()
        @Namespace var animation
        @State var selectedCardIndex: Int?
        
        var body: some View {
            TopBarView(
                room: room,
                deck: deck,
                pause: {},
                animationNamespace: animation,
                selectedCardIndex: $selectedCardIndex
            )
        }
    }
    
    return TopBarView_Preview()
}

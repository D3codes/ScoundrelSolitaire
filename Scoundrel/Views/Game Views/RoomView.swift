//
//  RoomView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import SwiftUI

struct RoomView: View {
    @Namespace private var animation
    
    @ObservedObject var room: Room
    @ObservedObject var player: Player
    let cardTapped: (Int, Bool) -> Void
    
    @State var cardSelected: Int?
    @State var topCard: Int = 5
    
    func closeSelectedView() {
        withAnimation { cardSelected = nil }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            topCard = 5
        }
    }
    
    func firstActionTapped() {
        let selectedCard: Int = cardSelected!
        closeSelectedView()
        cardTapped(selectedCard, true)
    }
    
    func secondActionTapped() {
        let selectedCard: Int = cardSelected!
        closeSelectedView()
        cardTapped(selectedCard, false)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(width: 150, height: 200)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(width: 150, height: 200)
                }
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(width: 150, height: 200)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(width: 150, height: 200)
                }
            }
            
            VStack {
                HStack {
                    CardOrSpacerView(
                        room: room,
                        cardIndex: 0,
                        cardSelected: $cardSelected,
                        topCard: $topCard,
                        animationNamespace: animation
                    )
                    
                    CardOrSpacerView(
                        room: room,
                        cardIndex: 1,
                        cardSelected: $cardSelected,
                        topCard: $topCard,
                        animationNamespace: animation
                    )
                }
                .zIndex(1)
                
                HStack {
                    CardOrSpacerView(
                        room: room,
                        cardIndex: 2,
                        cardSelected: $cardSelected,
                        topCard: $topCard,
                        animationNamespace: animation
                    )
                    
                    CardOrSpacerView(
                        room: room,
                        cardIndex: 3,
                        cardSelected: $cardSelected,
                        topCard: $topCard,
                        animationNamespace: animation
                    )
                }
                .zIndex(1)
            }
            
            if cardSelected != nil {
                SelectedCardView(
                    cardSelected: $cardSelected,
                    room: room,
                    player: player,
                    animationNamespace: animation,
                    cancel: closeSelectedView,
                    firstAction: firstActionTapped,
                    secondAction: secondActionTapped
                )
            }
        }
    }
}

#Preview {
    struct RoomView_Preview: View {
        @StateObject var room = Room(
            cards: [
                Card(suit: .monster, strength: 5),
                Card(suit: .healthPotion, strength: 5),
                Card(suit: .weapon, strength: 5),
                nil
            ],
            fleedLastRoom: false
        )
        
        func cardTapped(index: Int, bool: Bool) {
            withAnimation {
                room.cards[index] = nil
            }
        }
        
        @StateObject var player = Player()
        
        var body: some View {
            ZStack {
                RoomView(
                    room: room,
                    player: player,
                    cardTapped: cardTapped
                )
                
                VStack {
                    Spacer()
                    Button("Reset") {
                        withAnimation {
                            room.cards = [
                                Card(suit: .monster, strength: 5),
                                Card(suit: .healthPotion, strength: 5),
                                Card(suit: .weapon, strength: 5),
                                nil
                            ]
                        }
                    }
                }
            }
        }
    }
    
    return RoomView_Preview()
}


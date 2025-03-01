//
//  CardOrSpacerView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/26/25.
//

import SwiftUI

struct CardOrSpacerView: View {
    @ObservedObject var room: Room
    var cardIndex: Int
    @Binding var cardSelected: Int?
    @Binding var topCard: Int
    var animationNamespace: Namespace.ID
    
    var body: some View {
        Group {
            if room.cards[cardIndex] == nil || cardSelected == cardIndex {
                Rectangle()
                    .opacity(0)
                    .frame(width: 150, height: 200)
            } else {
                CardView(card: room.cards[cardIndex]!)
                    .onTapGesture {
                        topCard = cardIndex
                        withAnimation { cardSelected = cardIndex }
                    }
                    .matchedGeometryEffect(id: "Card\(cardIndex)", in: animationNamespace)
                    .zIndex(topCard == cardIndex ? 100 : 1)
            }
        }
        .frame(width: .infinity, height: .infinity)
    }
}

#Preview {
    struct CardOrSpacerView_Preview: View {
        @StateObject var room: Room = Room(cards: [Card(suit: .monster, strength: 11), nil, nil, nil], fleedLastRoom: false)
        @State var cardSelected: Int? = 1
        @State var topCard = 0
        @Namespace var animation
        
        var body: some View {
            CardOrSpacerView(
                room: room,
                cardIndex: 0,
                cardSelected: $cardSelected,
                topCard: $topCard,
                animationNamespace: animation
            )
        }
    }
    
    return CardOrSpacerView_Preview()
}

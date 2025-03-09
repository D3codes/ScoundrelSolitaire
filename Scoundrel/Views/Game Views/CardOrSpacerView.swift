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
                        if !room.isDealingCards {
                            withAnimation { cardSelected = cardIndex }
                        }
                    }
                    .matchedGeometryEffect(id: "Card\(cardIndex)", in: animationNamespace)
                    .transition(.opacityAndScale)
            }
        }
    }
}

#Preview {
    struct CardOrSpacerView_Preview: View {
        @StateObject var room: Room = Room([Card(suit: .monster, strength: 11), nil, nil, nil])
        @State var cardSelected: Int? = 1
        @Namespace var animation
        
        var body: some View {
            CardOrSpacerView(
                room: room,
                cardIndex: 0,
                cardSelected: $cardSelected,
                animationNamespace: animation
            )
        }
    }
    
    return CardOrSpacerView_Preview()
}

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
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .aspectRatio(0.75, contentMode: .fit)
                .glassEffect(in: .rect(cornerRadius: 20))
            
            Group {
                if room.cards[cardIndex] == nil || cardSelected == cardIndex {
                    Rectangle()
                        .opacity(0)
                        .aspectRatio(0.75, contentMode: .fit)
                } else {
                    Button {
                        if !room.isDealingCards {
                            withAnimation { cardSelected = cardIndex }
                        }
                    } label: {
                        CardView(card: room.cards[cardIndex]!)
                    }
                        .disabled(room.isDealingCards)
                        .accessibilityLabel("Card \(cardIndex + 1), \(room.cards[cardIndex]!.getFirstButtonText())")
                        .accessibilityHint("Selects this card")
                        .matchedGeometryEffect(
                            id: "Card\(cardIndex)",
                            in: animationNamespace,
                            properties: .position
                        )
                        .transition(.opacityAndScale)
                }
            }
        }
        .padding(1)
        .frame(maxWidth: 200)
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

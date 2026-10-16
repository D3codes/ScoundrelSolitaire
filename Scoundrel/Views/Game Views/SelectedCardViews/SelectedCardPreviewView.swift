//
//  SelectedCardPreviewView.swift
//  Scoundrel
//
//  Created by David Freeman on 9/28/26.
//

import SwiftUI

struct SelectedCardPreviewView: View {
    @Binding var cardSelected: Int?
    @ObservedObject var room: Room
    var animationNamespace: Namespace.ID
    
    var body: some View {
        Group {
            switch cardSelected {
            case 0:
                CardView(card: room.cards[cardSelected!]!)
                    .matchedGeometryEffect(id: "Card0", in: animationNamespace, properties: .position)
            case 1:
                CardView(card: room.cards[cardSelected!]!)
                    .matchedGeometryEffect(id: "Card1", in: animationNamespace, properties: .position)
            case 2:
                CardView(card: room.cards[cardSelected!]!)
                    .matchedGeometryEffect(id: "Card2", in: animationNamespace, properties: .position)
            case 3:
                CardView(card: room.cards[cardSelected!]!)
                    .matchedGeometryEffect(id: "Card3", in: animationNamespace, properties: .position)
            default:
                RoundedRectangle(cornerRadius: 20)
                    .opacity(0)
            }
        }
        .frame(maxWidth: 250)
        .transition(.opacityAndScale)
    }
}

#Preview {
    struct SelectedCardPreviewView_Preview: View {
        @StateObject var room: Room = Room([Card(suit: .monster, strength: 4), nil, nil, nil])
        @State var cardSelected: Int? = 0
        @Namespace var animation
        
        var body: some View {
            SelectedCardPreviewView(
                cardSelected: $cardSelected,
                room: room,
                animationNamespace: animation
            )
        }
    }
    
    return SelectedCardPreviewView_Preview()
}

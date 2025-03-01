//
//  SelectedCardView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/26/25.
//

import SwiftUI

struct SelectedCardView: View {
    @Binding var cardSelected: Int?
    @ObservedObject var room: Room
    @ObservedObject var player: Player
    var animationNamespace: Namespace.ID
    var cancel: () -> Void
    var firstAction: () -> Void
    var secondAction: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundStyle(.ultraThinMaterial)
                .opacity(0.5)
                .onTapGesture { cancel() }
            
            VStack {
                switch cardSelected {
                case 0:
                    CardView(card: room.cards[cardSelected!]!)
                        .matchedGeometryEffect(id: "Card0", in: animationNamespace)
                        .scaleEffect(1.2)
                        .padding(.bottom, 50)
                        .transition(.opacityAndScale)
                case 1:
                    CardView(card: room.cards[cardSelected!]!)
                        .matchedGeometryEffect(id: "Card1", in: animationNamespace)
                        .scaleEffect(1.2)
                        .padding(.bottom, 50)
                        .transition(.opacityAndScale)
                case 2:
                    CardView(card: room.cards[cardSelected!]!)
                        .matchedGeometryEffect(id: "Card2", in: animationNamespace)
                        .scaleEffect(1.2)
                        .padding(.bottom, 50)
                        .transition(.opacityAndScale)
                case 3:
                    CardView(card: room.cards[cardSelected!]!)
                        .matchedGeometryEffect(id: "Card3", in: animationNamespace)
                        .scaleEffect(1.2)
                        .padding(.bottom, 50)
                        .transition(.opacityAndScale)
                default:
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(width: 150, height: 200)
                        .opacity(0)
                }
                
                Button(action: { if cardSelected != nil { firstAction() } }, label: {
                    ZStack {
                        Image("plank1")
                            .resizable()
                            .frame(width: 300, height: 50)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        Text(
                            cardSelected == nil ? ""
                            : room.cards[cardSelected!]?.getFirstButtonText() ?? ""
                        )
                            .font(.custom("ModernAntiqua-Regular", size: 25))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                })
                
                if cardSelected != nil && !(room.cards[cardSelected!]?.getSecondButtonText() ?? "").isEmpty && player.canAttackWithWeapon(monsterStrength: room.cards[cardSelected!]!.strength) {
                    Button(action: { secondAction() }, label: {
                        ZStack {
                            Image("plank1")
                                .resizable()
                                .frame(width: 300, height: 50)
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                            Text(room.cards[cardSelected!]?.getSecondButtonText() ?? "")
                                .font(.custom("ModernAntiqua-Regular", size: 25))
                                .foregroundStyle(.white)
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                        }
                    })
                }
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    struct SelectedCardView_Preview: View {
        @StateObject var room: Room = Room(
            cards: [
                Card(suit: .monster, strength: 3),
                nil,
                nil,
                nil
            ],
            fleedLastRoom: false
        )
        @StateObject var player: Player = Player()
        @State var cardSelected: Int? = 0
        @Namespace var animation
        
        var body: some View {
            SelectedCardView(
                cardSelected: $cardSelected,
                room: room,
                player: player,
                animationNamespace: animation,
                cancel: {},
                firstAction: {},
                secondAction: {}
            )
        }
    }
    
    return SelectedCardView_Preview()
}

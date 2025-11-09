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
                Group {
                    switch cardSelected {
                    case 0:
                        CardView(card: room.cards[cardSelected!]!)
                            .matchedGeometryEffect(id: "Card0", in: animationNamespace)
                    case 1:
                        CardView(card: room.cards[cardSelected!]!)
                            .matchedGeometryEffect(id: "Card1", in: animationNamespace)
                    case 2:
                        CardView(card: room.cards[cardSelected!]!)
                            .matchedGeometryEffect(id: "Card2", in: animationNamespace)
                    case 3:
                        CardView(card: room.cards[cardSelected!]!)
                            .matchedGeometryEffect(id: "Card3", in: animationNamespace)
                    default:
                        RoundedRectangle(cornerRadius: 20)
                            .opacity(0)
                    }
                }
                .frame(maxWidth: 250)
                .padding(.bottom, 50)
                .transition(.opacityAndScale)
                
                Button(action: { if cardSelected != nil { firstAction() } }, label: {
                    ZStack {
                        Image("plank1")
                            .resizable()
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        HStack {
                            Text(
                                cardSelected == nil ? ""
                                : room.cards[cardSelected!]?.getFirstButtonText() ?? ""
                            )
                            .font(.custom("ModernAntiqua-Regular", size: 25))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            
                            if cardSelected != nil && room.cards[cardSelected!]?.suit == .monster {
                                ZStack {
                                    Image("heart1")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                    
                                    Text("-\(room.cards[cardSelected!]?.strength ?? 0)")
                                        .font(.custom("ModernAntiqua-Regular", size: 25))
                                        .foregroundStyle(.white)
                                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                })
                .frame(width: 300, height: 50)
                
                if cardSelected != nil && !(room.cards[cardSelected!]?.getSecondButtonText() ?? "").isEmpty && player.canAttackWithWeapon(monsterStrength: room.cards[cardSelected!]!.strength) {
                    Button(action: { secondAction() }, label: {
                        ZStack {
                            Image("plank1")
                                .resizable()
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                            
                            HStack {
                                Text(room.cards[cardSelected!]?.getSecondButtonText() ?? "")
                                    .font(.custom("ModernAntiqua-Regular", size: 25))
                                    .foregroundStyle(.white)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                                
                                if cardSelected != nil && room.cards[cardSelected!]?.suit == .monster {
                                    ZStack {
                                        Image("heart1")
                                            .resizable()
                                            .frame(width: 45, height: 45)
                                        
                                        Text("-\(max((room.cards[cardSelected!]?.strength ?? 0) - player.weapon!, 0))")
                                            .font(.custom("ModernAntiqua-Regular", size: 25))
                                            .foregroundStyle(.white)
                                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    })
                    .frame(width: 300, height: 50)
                }
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    struct SelectedCardView_Preview: View {
        @StateObject var room: Room = Room([Card(suit: .monster, strength: 4), nil, nil, nil])
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
            .onAppear {
                player.weapon = 5
            }
        }
    }
    
    return SelectedCardView_Preview()
}

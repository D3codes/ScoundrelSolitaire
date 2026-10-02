//
//  SelectedCardActionsView.swift
//  Scoundrel
//
//  Created by David Freeman on 9/28/26.
//

import SwiftUI

struct SelectedCardActionsView: View {
    @Binding var cardSelected: Int?
    @ObservedObject var room: Room
    @ObservedObject var player: Player
    var animationNamespace: Namespace.ID
    var cancel: () -> Void
    var firstAction: () -> Void
    var secondAction: () -> Void
    
    var body: some View {
        VStack {
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
}

#Preview {
    struct SelectedCardActionsView_Preview: View {
        @StateObject var room: Room = Room([Card(suit: .monster, strength: 4), nil, nil, nil])
        @StateObject var player: Player = Player()
        @State var cardSelected: Int? = 0
        @Namespace var animation
        
        var body: some View {
            SelectedCardActionsView(
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
    
    return SelectedCardActionsView_Preview()
}

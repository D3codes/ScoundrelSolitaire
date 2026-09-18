//
//  RoomView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import SwiftUI

struct RoomView: View {
    var animationNamespace: Namespace.ID
    
    @ObservedObject var room: Room
    
    @Binding var cardSelected: Int?
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            ZStack {
                if isLandscape {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 0,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 1,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 2,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 3,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 0,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 1,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 2,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            CardOrSpacerView(
                                room: room,
                                cardIndex: 3,
                                cardSelected: $cardSelected,
                                animationNamespace: animationNamespace
                            )
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    struct RoomView_Preview: View {
        @StateObject var room = Room([nil, nil, nil, Card(suit: .monster, strength: 5)])
        
        func actionSelected(index: Int, bool: Bool) {
            withAnimation {
                room.cards[index] = nil
            }
        }
        
        @StateObject var player = Player()
        @Namespace var animation
        
        @State var cardSelected: Int?
        
        var body: some View {
            ZStack {
                RoomView(
                    animationNamespace: animation,
                    room: room,
                    cardSelected: $cardSelected
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


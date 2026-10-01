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

    @ViewBuilder
    private func card(at index: Int) -> some View {
        CardOrSpacerView(
            room: room,
            cardIndex: index,
            cardSelected: $cardSelected,
            animationNamespace: animationNamespace
        )
    }

    private func cardPair(_ firstIndex: Int, _ secondIndex: Int) -> some View {
        HStack {
            Spacer()
            card(at: firstIndex)
            card(at: secondIndex)
            Spacer()
        }
    }

    private var cardRow: some View {
        HStack {
            Spacer()
            card(at: 0)
            card(at: 1)
            card(at: 2)
            card(at: 3)
            Spacer()
        }
    }

    private var cardGrid: some View {
        VStack {
            Spacer()
            cardPair(0, 1)
            cardPair(2, 3)
            Spacer()
        }
    }

    @ViewBuilder
    private func roomLayout(isLandscape: Bool) -> some View {
        if isLandscape {
            VStack {
                Spacer()
                cardRow
                Spacer()
            }
        } else {
            cardGrid
        }
    }

    @available(iOS 27.1, *)
    @ViewBuilder
    private func foldAwareRoomLayout(in geometry: GeometryProxy, fold: ReservedRegion) -> some View {
        let leftRegionWidth = fold.frame.minX
        let rightRegionWidth = max(0, geometry.size.width - fold.frame.maxX)
        let cardRegionWidth = min(leftRegionWidth, rightRegionWidth)

        ZStack {
            cardPair(0, 1)
                .frame(width: cardRegionWidth, height: geometry.size.height)
                .position(
                    x: fold.frame.minX - (cardRegionWidth / 2),
                    y: geometry.size.height / 2
                )

            cardPair(2, 3)
                .frame(width: cardRegionWidth, height: geometry.size.height)
                .position(
                    x: fold.frame.maxX + (cardRegionWidth / 2),
                    y: geometry.size.height / 2
                )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            if #available(iOS 27.1, *), isLandscape, let fold = geometry.dividingReservedRegion {
                foldAwareRoomLayout(in: geometry, fold: fold)
            } else {
                roomLayout(isLandscape: isLandscape)
            }
        }
        .frame(minHeight: 100)
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

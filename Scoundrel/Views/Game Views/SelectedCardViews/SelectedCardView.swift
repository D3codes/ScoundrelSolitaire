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

    private func selectedCardContent() -> some View {
        VStack {
            SelectedCardPreviewView(
                cardSelected: $cardSelected,
                room: room,
                animationNamespace: animationNamespace
            )
            .padding(.bottom, 50)

            SelectedCardActionsView(
                cardSelected: $cardSelected,
                room: room,
                player: player,
                animationNamespace: animationNamespace,
                cancel: cancel,
                firstAction: firstAction,
                secondAction: secondAction
            )
        }
    }

    @available(iOS 27.1, *)
    @ViewBuilder
    private func foldAwareContent(in geometry: GeometryProxy, fold: ReservedRegion) -> some View {
        let isLandscape: Bool = fold.frame.height > fold.frame.width
        if isLandscape {
            let selectedCardOnLeft: Bool = cardSelected ?? 0 < 2
            let width: CGFloat = selectedCardOnLeft ? fold.frame.minX : max(0, geometry.size.width - fold.frame.maxX)
            let alignment: Alignment = selectedCardOnLeft ? .leading : .trailing
            
            selectedCardContent()
                .frame(width: width, height: geometry.size.height)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        } else {
            ZStack {
                SelectedCardPreviewView(
                    cardSelected: $cardSelected,
                    room: room,
                    animationNamespace: animationNamespace
                )
                .frame(width: geometry.size.width, height: fold.frame.minY)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                SelectedCardActionsView(
                    cardSelected: $cardSelected,
                    room: room,
                    player: player,
                    animationNamespace: animationNamespace,
                    cancel: cancel,
                    firstAction: firstAction,
                    secondAction: secondAction
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }

    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundStyle(.ultraThinMaterial)
                .opacity(0.5)
                .onTapGesture { cancel() }

            GeometryReader { geometry in
                if #available(iOS 27.1, *), let fold = geometry.dividingReservedRegion {
                    foldAwareContent(in: geometry, fold: fold)
                } else {
                    selectedCardContent()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

//
//  HealthView.swift
//  Scoundrel
//
//  Created by David Freeman on 9/17/26.
//

import SwiftUI

struct HealthView: View {
    @AppStorage(UserDefaultsKeys().hapticsEnabled) private var hapticsEnabled: Bool = true
    
    @ObservedObject var room: Room
    @ObservedObject var player: Player
    var animationNamespace: Namespace.ID
    
    var body: some View {
        ZStack {
            ForEach(0..<4) { index in
                if room.cards[index] == nil && room.destinations[index] == .health {
                    Rectangle()
                        .opacity(0)
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(
                            id: "Card\(index)",
                            in: animationNamespace,
                            properties: .position
                        )
                }
            }
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
                .glassEffect(in: .rect(cornerRadius: 10))
            
            if hapticsEnabled {
                VStack(spacing: 0) {
                    Image("heart1")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("\(player.health)")
                        .font(.custom("MorrisRoman-Black", size: 20))
                        .contentTransition(.numericText())
                }
                .sensoryFeedback(trigger: player.health) { oldValue, newValue in
                    if oldValue > newValue {
                        return .error
                    }
                    return .success
                }
            } else {
                VStack(spacing: 0) {
                    Image("heart1")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("\(player.health)")
                        .font(.custom("MorrisRoman-Black", size: 20))
                        .contentTransition(.numericText())
                }
            }
        }
        .scaleEffect(player.healthIconSize)
        .animation(.spring(duration: 0.5, bounce: 0.6), value: player.healthIconSize)
    }
}

#Preview {
    struct HealthView_Preview: View {
        @StateObject var player: Player = Player()
        @StateObject var room: Room = Room()
        @Namespace var animation
        
        var body: some View {
            HealthView(
                room: room,
                player: player,
                animationNamespace: animation
            )
        }
    }
    
    return HealthView_Preview()
}

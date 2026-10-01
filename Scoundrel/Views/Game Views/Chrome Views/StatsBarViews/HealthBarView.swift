//
//  HealthBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/1/25.
//

import SwiftUI

struct HealthBarView: View {
    @AppStorage(UserDefaultsKeys().hapticsEnabled) private var hapticsEnabled: Bool = true
    
    @ObservedObject var room: Room
    @ObservedObject var player: Player
    var animationNamespace: Namespace.ID
    
    var body: some View {
        HStack {
            HealthView(
                room: room,
                player: player,
                animationNamespace: animationNamespace
            )
            
            ZStack {
                Capsule()
                    .glassEffect()
                
                Capsule()
                    .foregroundStyle(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .red, location: 0),
                                Gradient.Stop(color: .red, location: CGFloat(player.health).map(from: 0...20, to: 0...1)),
                                Gradient.Stop(color: .white.opacity(0), location: CGFloat(player.health).map(from: 0...20, to: 0...1))
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .glassEffect(.clear)
            }
            .frame(height: 10)
            
            Spacer()
        }
    }
}

#Preview {
    struct HealthBarView_Preview: View {
        @StateObject var player: Player = Player()
        @StateObject var room: Room = Room()
        @Namespace var animation
        
        var body: some View {
            HealthBarView(
                room: room,
                player: player,
                animationNamespace: animation
            )
        }
    }
    
    return HealthBarView_Preview()
}

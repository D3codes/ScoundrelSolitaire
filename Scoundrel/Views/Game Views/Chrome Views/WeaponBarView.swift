//
//  WeaponBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/1/25.
//

import SwiftUI

struct WeaponBarView: View {
    @AppStorage(UserDefaultsKeys().hapticsEnabled) private var hapticsEnabled: Bool = true
    
    @ObservedObject var player: Player
    @ObservedObject var room: Room
    var animationNamespace: Namespace.ID
    
    @State var isShowingWeaponPopover: Bool = false
    
    var body: some View {
        HStack {
            WeaponView(
                player: player,
                room: room,
                animationNamespace: animationNamespace
            )
            
            ZStack {
                Capsule()
                    .glassEffect()
                
                Capsule()
                    .foregroundStyle(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .green, location: 0),
                                Gradient.Stop(color: .green, location: CGFloat(player.strongestMonsterThatCanBeAttacked()).map(from: 0...14, to: 0...1)),
                                Gradient.Stop(color: .white.opacity(0), location: CGFloat(player.strongestMonsterThatCanBeAttacked()).map(from: 0...14, to: 0...1))
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
    struct WeaponBarView_Preview: View {
        @StateObject var player: Player = Player()
        @StateObject var room: Room = Room()
        @Namespace var animation
        
        var body: some View {
            WeaponBarView(
                player: player,
                room: room,
                animationNamespace: animation
            )
        }
    }
    
    return WeaponBarView_Preview()
}

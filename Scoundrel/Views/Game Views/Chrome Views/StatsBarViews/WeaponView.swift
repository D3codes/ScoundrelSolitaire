//
//  WeaponView.swift
//  Scoundrel
//
//  Created by David Freeman on 9/17/26.
//

import SwiftUI

struct WeaponView: View {
    @AppStorage(UserDefaultsKeys().hapticsEnabled) private var hapticsEnabled: Bool = true
    
    @ObservedObject var player: Player
    @ObservedObject var room: Room
    var animationNamespace: Namespace.ID
    
    @State var isShowingWeaponPopover: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
                .glassEffect(in: .rect(cornerRadius: 10))
            
            VStack(spacing: 0) {
                Image("shield1")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("\(player.weapon ?? 0)")
                    .font(.custom("MorrisRoman-Black", size: 20))
                    .contentTransition(.numericText())
            }
        }
        .scaleEffect(player.shieldIconSize)
        .animation(.spring(duration: 0.5, bounce: 0.6), value: player.shieldIconSize)
        
        ZStack {
            ForEach(0..<4) { index in
                if room.cards[index] == nil && room.destinations[index] == .weapon {
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
                    Image("sword1")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("\(player.strongestMonsterThatCanBeAttacked())")
                        .font(.custom("MorrisRoman-Black", size: 20))
                        .contentTransition(.numericText())
                }
                .sensoryFeedback(.impact, trigger: player.lastAttacked ?? 0)
            } else {
                VStack(spacing: 0) {
                    Image("sword1")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("\(player.strongestMonsterThatCanBeAttacked())")
                        .font(.custom("MorrisRoman-Black", size: 20))
                        .contentTransition(.numericText())
                }
            }
        }
        .scaleEffect(player.weaponIconSize)
        .animation(.spring(duration: 0.5, bounce: 0.6), value: player.weaponIconSize)
        .onTapGesture { isShowingWeaponPopover = true }
        .popover(isPresented: $isShowingWeaponPopover) {
            Text("Can attack monsters with strength \(player.strongestMonsterThatCanBeAttacked()) or less")
                .fixedSize(horizontal: false, vertical: true)
                .font(.headline)
                .padding()
                .presentationCompactAdaptation(.popover)
        }
    }
}

#Preview {
    struct WeaponView_Preview: View {
        @StateObject var player: Player = Player()
        @StateObject var room: Room = Room()
        @Namespace var animation
        
        var body: some View {
            WeaponView(
                player: player,
                room: room,
                animationNamespace: animation
            )
        }
    }
    
    return WeaponView_Preview()
}

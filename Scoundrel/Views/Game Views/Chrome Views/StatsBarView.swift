//
//  StatsBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import SwiftUI

struct StatsBarView: View {
    @ObservedObject var player: Player
    @ObservedObject var room: Room
    var animationNamespace: Namespace.ID
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                HealthBarView(
                    room: room,
                    player: player,
                    animationNamespace: animationNamespace
                )
                .padding(.horizontal)
                .frame(minWidth: 200, maxWidth: 500)
                
                WeaponBarView(
                    player: player,
                    room: room,
                    animationNamespace: animationNamespace
                )
                .padding(.horizontal)
                .frame(minWidth: 300,maxWidth: 500)
            }
            
            ViewThatFits(in: .vertical) {
                VStack {
                    HealthBarView(
                        room: room,
                        player: player,
                        animationNamespace: animationNamespace
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    .frame(maxWidth: 500)
                    
                    WeaponBarView(
                        player: player,
                        room: room,
                        animationNamespace: animationNamespace
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                    .frame(maxWidth: 500)
                }
                .frame(maxHeight: 150)
                
                HStack {
                    HealthView(
                        room: room,
                        player: player,
                        animationNamespace: animationNamespace
                    )
                    
                    WeaponView(
                        player: player,
                        room: room,
                        animationNamespace: animationNamespace
                    )
                }
            }
        }
    }
}

#Preview {
    
    struct StatsBarView_Preview: View {
        @StateObject var player: Player = Player()
        @StateObject var room: Room = Room()
        @Namespace var animation
        
        var body: some View {
            
            VStack {
                HStack{
                    Button("-") { player.attack(monsterStrength: 5) }
                    Text("Health")
                    Button("+") { player.useHealthPotion(potionStrength: 5) }
                }
                HStack{
                    Button("-") { player.attack(withWeapon: true, monsterStrength: 5) }
                    Text("Weapon")
                    Button("+") { player.equipWeapon(weaponStrength: 5) }
                }
                
                StatsBarView(
                    player: player,
                    room: room,
                    animationNamespace: animation
                )
            }
        }
    }
    
    return StatsBarView_Preview()
}


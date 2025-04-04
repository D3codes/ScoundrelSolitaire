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
        VStack {
            Spacer()
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
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(
            Image("wood2")
                .resizable()
                .ignoresSafeArea()
                .shadow(color: .black, radius: 5, x: 0, y: -5)
        )
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


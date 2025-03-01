//
//  PlayerView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var player: Player
    @ObservedObject var room: Room
    var animationNamespace: Namespace.ID
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                        
                    VStack(spacing: 0) {
                        Image("heart1")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(player.health)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
                .scaleEffect(player.healthIconSize)
                .animation(.spring(duration: 0.5, bounce: 0.6), value: player.healthIconSize)
                
                ZStack {
                    Capsule()
                        .foregroundStyle(.ultraThinMaterial)
                        .shadow(color: .black, radius: 5)

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
                    
                    Capsule()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white, .gray, .black]), startPoint: .top, endPoint: .bottom))
                }
                .frame(height: 10)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            HStack {
                ZStack {
                    ForEach(0..<4) { index in
                        if room.cards[index] == nil {
                            Rectangle()
                                .opacity(0)
                                .frame(width: 50, height: 50)
                                .matchedGeometryEffect(id: "Card\(index)", in: animationNamespace)
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
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
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                    VStack(spacing: 0) {
                        Image("sword1")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(player.strongestMonsterThatCanBeAttacked())")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
                .scaleEffect(player.weaponIconSize)
                .animation(.spring(duration: 0.5, bounce: 0.6), value: player.weaponIconSize)
                
                ZStack {
                    Capsule()
                        .foregroundStyle(.ultraThinMaterial)
                        .shadow(color: .black, radius: 5)

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
                    
                    Capsule()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white, .gray, .black]), startPoint: .top, endPoint: .bottom))
                }
                .frame(height: 10)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(
            Image("woodButton")
                .resizable()
                .frame(width: 800)
                .ignoresSafeArea()
                .shadow(color: .black, radius: 5, x: 0, y: -5)
        )
    }
}

#Preview {
    
    struct PlayerView_Preview: View {
        @StateObject var player: Player = Player()
        @StateObject var room: Room = Room(cards: [nil, nil, nil, nil], fleedLastRoom: false)
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
                
                PlayerView(
                    player: player,
                    room: room,
                    animationNamespace: animation
                )
            }
        }
    }
    
    return PlayerView_Preview()
}


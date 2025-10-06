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
            ZStack {
                if #available(iOS 26.0, *) { // glass effect not available on older OS versions
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .glassEffect(in: .rect(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                }
                
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
                            .matchedGeometryEffect(id: "Card\(index)", in: animationNamespace)
                    }
                }
                
                if #available(iOS 26.0, *) { // glass effect not available on older OS versions
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .glassEffect(in: .rect(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                }
                
                if #available(iOS 17.0, *), hapticsEnabled { // sensory feedback not available on older OS versions
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
            .onTapGesture {
                if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                    isShowingWeaponPopover = true
                }
            }
            .popover(isPresented: $isShowingWeaponPopover) {
                if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                    Text("Can attack monsters with strength \(player.strongestMonsterThatCanBeAttacked()) or less")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
            }
            
            ZStack {
                if #available(iOS 26.0, *) { // glass effect not available on older OS versions
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
                } else {
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

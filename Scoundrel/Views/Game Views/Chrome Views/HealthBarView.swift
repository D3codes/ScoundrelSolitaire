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
            ZStack {
                ForEach(0..<4) { index in
                    if room.cards[index] == nil && room.destinations[index] == .health {
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
            
            ZStack {
                if #available(iOS 26.0, *) { // glass effect not available on older OS versions
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
                } else {
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

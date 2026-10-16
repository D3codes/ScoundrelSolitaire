//
//  ThemePreviewView.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

import SwiftUI
import Foundation

struct ThemePreviewView: View {
    private let cardDesignSize = CGSize(width: 180, height: 240)

    var theme: ThemeHelper.Theme
    var isSelected: Bool
    
    @State private var monsterStrength: Int = 2
    @State private var weaponStrength: Int = 2
    @State private var healthStrength: Int = 2
    
    var body: some View {
        VStack {
            HStack {
                Text(theme.rawValue)
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.foreground)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
            
            HStack {
                scaledCard(suit: .monster, strength: monsterStrength)
                scaledCard(suit: .weapon, strength: weaponStrength)
                scaledCard(suit: .healthPotion, strength: healthStrength)
            }
        }
        .task {
            while !Task.isCancelled {
                do {
                    try await Task.sleep(for: .seconds(Double.random(in: 1...5)))
                } catch {
                    return
                }

                withAnimation {
                    monsterStrength = Int.random(in: 2...14)
                }
            }
        }
        .task {
            while !Task.isCancelled {
                do {
                    try await Task.sleep(for: .seconds(Double.random(in: 1...5)))
                } catch {
                    return
                }

                withAnimation {
                    weaponStrength = Int.random(in: 2...10)
                }
            }
        }
        .task {
            while !Task.isCancelled {
                do {
                    try await Task.sleep(for: .seconds(Double.random(in: 1...5)))
                } catch {
                    return
                }

                withAnimation {
                    healthStrength = Int.random(in: 2...10)
                }
            }
        }
    }

    private func scaledCard(suit: Card.Suit, strength: Int) -> some View {
        GeometryReader { proxy in
            let scale = proxy.size.width / cardDesignSize.width

            CardView(
                card: Card(suit: suit, strength: strength),
                themePreview: theme
            )
            .frame(width: cardDesignSize.width, height: cardDesignSize.height)
            .scaleEffect(scale, anchor: .topLeading)
        }
        .aspectRatio(cardDesignSize.width / cardDesignSize.height, contentMode: .fit)
    }
}

#Preview {
    ThemePreviewView(theme: .Sketch, isSelected: true)
}

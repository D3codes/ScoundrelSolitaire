//
//  ThemePreviewView.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

import SwiftUI
import Foundation

struct ThemePreviewView: View {
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
                CardView(card: Card(suit: .monster, strength: monsterStrength), themePreview: theme)
                CardView(card: Card(suit: .weapon, strength: weaponStrength), themePreview: theme)
                CardView(card: Card(suit: .healthPotion, strength: healthStrength), themePreview: theme)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                self.monsterStrength = Int.random(in: 2...14)
                self.weaponStrength = Int.random(in: 2...10)
                self.healthStrength = Int.random(in: 2...10)
            }
        }
    }
}

#Preview {
    ThemePreviewView(theme: .Sketch, isSelected: true)
}

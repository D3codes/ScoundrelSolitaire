//
//  PixelatedTheme.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

import SwiftUI

struct PixelatedTheme {
    
    func getCardBackgroundName() -> String {
        return "pix_paper"
    }
    
    func getCardImageName(suit: Card.Suit, strength: Int) -> String {
        switch suit {
        case .healthPotion:
            if strength < 5 {
                return "pix_smallHealthPotion"
            } else if strength < 8 {
                return "pix_mediumHealthPotion"
            } else {
                return "pix_largeHealthPotion"
            }
        case .weapon:
            return "pix_weapon\(strength)"
        default:
            return "pix_monster\(strength)"
        }
    }
}

#Preview {
    ThemePreviewView(theme: .Pixelated, isSelected: true)
}

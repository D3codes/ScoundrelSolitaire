//
//  Card.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import SwiftUI

class Card: ObservableObject, Codable {
    enum Suit: String, CaseIterable, Codable {
        case weapon
        case healthPotion
        case monster
    }
    
    var suit: Suit
    var strength: Int
    
    init(suit: Suit, strength: Int) {
        guard strength >= 2 else {
            fatalError("")
        }
        
        guard strength <= 14 else {
            fatalError("")
        }
        
        if suit != .monster {
            guard strength <= 10 else {
                fatalError("")
            }
        }
        
        self.suit = suit
        self.strength = strength
    }
    
    func getBackgroundName(themePreview: ThemeHelper.Theme?) -> String {
        return ThemeHelper(themePreview: themePreview).getCardBackgroundName()
    }
    
    func getImageName(themePreview: ThemeHelper.Theme?) -> String {
        return ThemeHelper(themePreview: themePreview).getCardImageName(suit: suit, strength: strength)
    }
    
    func getIcon() -> String {
        switch suit {
        case .healthPotion:
            return "heart1"
        case .weapon:
            return "sword1"
        case .monster:
            return "dragon1"
        }
    }
    
    func getFirstButtonText() -> String {
        switch suit {
        case .healthPotion:
            "Drink"
        case .weapon:
            "Equip"
        case .monster:
            "Unarmed"
        }
    }
    
    func getSecondButtonText() -> String {
        switch suit {
        case .monster:
            "Weapon"
        default:
            ""
        }
    }
}

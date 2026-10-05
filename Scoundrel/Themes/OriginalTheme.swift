//
//  OriginalTheme.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

struct OriginalTheme {
    
    func getCardBackgroundName() -> String {
        return "paper"
    }
    
    func getCardImageName(suit: Card.Suit, strength: Int) -> String {
        switch suit {
        case .healthPotion:
            if strength < 5 {
                return "healthPotion2"
            } else if strength < 8 {
                return "healthPotion5"
            } else {
                return "healthPotion8"
            }
        case .weapon:
            return "weapon\(strength)"
        default:
            return "monster\(strength)"
        }
    }
}

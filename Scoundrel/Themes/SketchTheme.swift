//
//  SketchTheme.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

struct SketchTheme {
    
    func getCardBackgroundName() -> String {
        return "hd_paper"
    }
    
    func getCardImageName(suit: Card.Suit, strength: Int) -> String {
        switch suit {
        case .healthPotion:
            if strength < 5 {
                return "hd_smallHealthPotion"
            } else if strength < 8 {
                return "hd_mediumHealthPotion"
            } else {
                return "hd_largeHealthPotion"
            }
        case .weapon:
            return "hd_weapon\(strength)"
        default:
            return "hd_monster\(strength)"
        }
    }
}

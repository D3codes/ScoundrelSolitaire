//
//  Deck.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI

class Deck: ObservableObject {
    var cards: [Card] = []
    
    let combinedStrengthOfAllMonsterCards: Int = 208
    let animationDelay: CGFloat = 0.3
    let scaleAmount: CGFloat = 0.1
    @Published var iconSize: CGFloat = 1
    
    init() {
        reset()
    }
    
    func reset() {
        cards = []
        
        cards = [
            Card(suit: .monster, strength: 14),
//            Card(suit: .monster, strength: 5),
//            Card(suit: .healthPotion, strength: 2),
//            Card(suit: .healthPotion, strength: 10),
//            Card(suit: .weapon, strength: 2),
//            Card(suit: .weapon, strength: 2)
        ]
        
//        for i in 2...14 {
//            cards.append(Card(suit: .monster, strength: i))
//            cards.append(Card(suit: .monster, strength: i))
//            
//            if i < 11 {
//                cards.append(Card(suit: .healthPotion, strength: i))
//                cards.append(Card(suit: .weapon, strength: i))
//            }
//        }
        
        cards.shuffle()
    }
    
    func appendCards(_ cards: [Card]) {
        self.cards.append(contentsOf: cards)
        
        self.iconSize = 1.1
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            self.iconSize = 1
        }
    }
    
    func getTopCard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        
        self.iconSize -= scaleAmount
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            self.iconSize = 1
        }
        
        return cards.removeFirst()
    }
}

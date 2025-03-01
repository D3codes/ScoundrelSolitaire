//
//  Deck.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI

class Deck: ObservableObject {
    var cards: [Card] = []
    
    let animationDelay: CGFloat = 0.3
    let scaleAmount: CGFloat = 0.1
    @Published var iconSize: CGFloat = 1
    
    init() {
        for i in 2...14 {
            cards.append(Card(suit: .monster, strength: i))
            cards.append(Card(suit: .monster, strength: i))
            
            if i < 11 {
                cards.append(Card(suit: .healthPotion, strength: i))
                cards.append(Card(suit: .weapon, strength: i))
            }
        }
        
        cards.shuffle()
    }
    
    func reset() {
        cards = []
        
        for i in 2...14 {
            cards.append(Card(suit: .monster, strength: i))
            cards.append(Card(suit: .monster, strength: i))
            
            if i < 11 {
                cards.append(Card(suit: .healthPotion, strength: i))
                cards.append(Card(suit: .weapon, strength: i))
            }
        }
        
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
        self.iconSize -= scaleAmount
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            self.iconSize = 1
        }
        
        return cards.removeFirst()
    }
    
    func getScore() -> Int {
        return cards.reduce(0) { $0 - ($1.suit == .monster ? $1.strength : 0) }
    }
}

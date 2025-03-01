//
//  Deck.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI

class Deck: ObservableObject {
    var cards: [Card] = []
    
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
    }
    
    func getScore() -> Int {
        return cards.reduce(0) { $0 - ($1.suit == .monster ? $1.strength : 0) }
    }
}

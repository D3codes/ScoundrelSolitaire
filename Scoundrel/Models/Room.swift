//
//  Room.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI

class Room: ObservableObject {
    @Published var canFlee: Bool
    @Published var cards: [Card?]
    @Published var usedHealthPotion: Bool
    
    init(cards: [Card?], fleedLastRoom: Bool) {
        guard cards.count == 4 else {
            fatalError("")
        }
        
        self.cards = cards
        self.canFlee = !fleedLastRoom
        self.usedHealthPotion = false
    }
    
    func reset(cards: [Card?], fleedLastRoom: Bool) {
        self.cards = cards
        self.canFlee = !fleedLastRoom
        self.usedHealthPotion = false
    }
    
    func removeCard(at index: Int) {
        cards[index] = nil
    }
    
    func flee(deck: Deck) {
        for i in 0...3 {
            if cards[i] != nil {
                deck.appendCards([cards[i]!])
                cards[i] = nil
            }
        }
        
        nextRoom(deck: deck, fleedLastRoom: true)
    }
    
    func nextRoom(deck: Deck, fleedLastRoom: Bool) {
        for i in 0...3 {
            if cards[i] == nil {
                if !deck.cards.isEmpty {
                    cards[i] = deck.cards.removeFirst()
                }
            }
        }
        
        canFlee = !fleedLastRoom
        usedHealthPotion = false
    }
}

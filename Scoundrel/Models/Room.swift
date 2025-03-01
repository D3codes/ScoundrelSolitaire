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
    let animationDelay: Double = 0.5
    
    enum CardDestination: String, CaseIterable {
        case health
        case weapon
        case deck
    }
    
    @Published var destinations: [CardDestination] = [.deck, .deck, .deck, .deck]
    
    func setDestinations() {
        for i in 0...3 {
            if cards[i] == nil {
                destinations[i] = .deck
                continue
            }
            
            switch cards[i]!.suit {
            case .healthPotion:
                destinations[i] = .health
                break
            case .weapon:
                destinations[i] = .weapon
                break
            default:
                destinations[i] = .deck
            }
        }
    }
    
    init(cards: [Card?], fleedLastRoom: Bool) {
        guard cards.count == 4 else {
            fatalError("")
        }
        
        self.cards = cards
        self.canFlee = !fleedLastRoom
        self.usedHealthPotion = false
        setDestinations()
    }
    
    func reset(deck: Deck) {
        self.usedHealthPotion = false
        cards = [nil, nil, nil, nil]
        nextRoom(deck: deck, fleedLastRoom: false)
    }
    
    func removeCard(at index: Int) {
        withAnimation {
            cards[index] = nil
        }
    }
    
    func flee(deck: Deck) {
        for i in 0...3 {
            if cards[i] != nil {
                deck.appendCards([cards[i]!])
                withAnimation(.spring()) {
                    cards[i] = nil
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            self.nextRoom(deck: deck, fleedLastRoom: true)
        }
    }
    
    func nextRoom(deck: Deck, fleedLastRoom: Bool) {
        var dealingGap: Double = animationDelay
        for i in 0...3 {
            if cards[i] == nil {
                if !deck.cards.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + dealingGap) {
                        withAnimation(.spring()) {
                            self.cards[i] = deck.getTopCard()
                        }
                    }
                    dealingGap += animationDelay
                }
            }
        }
        
        canFlee = !fleedLastRoom
        usedHealthPotion = false
        setDestinations()
    }
}

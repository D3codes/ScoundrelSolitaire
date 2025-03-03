//
//  Room.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import AVFoundation

class Room: ObservableObject {
    @Published var canFlee: Bool
    @Published var cards: [Card?]
    @Published var usedHealthPotion: Bool
    let animationDelay: Double = 0.5
    
    var dealCardSound: AVAudioPlayer?
    var shuffleSound: AVAudioPlayer?
    
    @Published var lockCardSelection: Bool = false
    
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
            case .monster:
                destinations[i] = .weapon
            }
        }
    }
    
    init(cards: [Card?], fleedLastRoom: Bool) {
        guard cards.count == 4 else {
            fatalError("")
        }

        do {
            dealCardSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "dealingCard.m4a", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }

        do {
            shuffleSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "shuffle.mp3", ofType:nil)!))
            shuffleSound?.setVolume(5, fadeDuration: .zero)
        } catch {
            // couldn't load file :(
        }
        
        self.cards = cards
        self.canFlee = !fleedLastRoom
        self.usedHealthPotion = false
        self.lockCardSelection = false
        setDestinations()
    }
    
    func reset(deck: Deck) {
        self.usedHealthPotion = false
        cards = [nil, nil, nil, nil]
        nextRoom(deck: deck, fleedLastRoom: false)
        lockCardSelection = false
    }
    
    func removeCard(at index: Int) {
        withAnimation {
            cards[index] = nil
        }
    }
    
    func flee(deck: Deck) {
        destinations = [.deck, .deck, .deck, .deck]
        shuffleSound?.play()
        
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
        setDestinations()
        var dealingGap: Double = animationDelay
        for i in 0...3 {
            if cards[i] == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + dealingGap) {
                    withAnimation(.spring()) {
                        self.cards[i] = deck.getTopCard()
                        if self.cards[i] != nil {
                            self.dealCardSound?.stop()
                            self.dealCardSound?.play()
                        }
                        self.setDestinations()
                    }
                }
                dealingGap += animationDelay
            }
            
            if i == 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + dealingGap) {
                    self.lockCardSelection = false
                }
            }
        }
        
        canFlee = !fleedLastRoom
        usedHealthPotion = false
    }
}

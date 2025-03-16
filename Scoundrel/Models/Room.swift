//
//  Room.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import AVFoundation

class Room: ObservableObject, Codable {
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    
    @Published var canFlee: Bool
    @Published var cards: [Card?]
    @Published var usedHealthPotion: Bool
    let animationDelay: Double = 0.5
    
    @Published var playerFleed: Bool = false
    
    var shuffleSound: AVAudioPlayer?
    var dealCardSounds: [AVAudioPlayer?] = [nil, nil, nil, nil]
    
    @Published var isDealingCards: Bool = false
    
    @Published var destinations: [CardDestination] = [.deck, .deck, .deck, .deck]
    enum CardDestination: String, CaseIterable, Codable {
        case health
        case weapon
        case deck
    }
    
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
    
    func initializeSounds() {
        do {
            dealCardSounds[0] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "dealingCard.m4a", ofType:nil)!))
            dealCardSounds[1] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "dealingCard.m4a", ofType:nil)!))
            dealCardSounds[2] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "dealingCard.m4a", ofType:nil)!))
            dealCardSounds[3] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "dealingCard.m4a", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }

        do {
            shuffleSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "shuffle.mp3", ofType:nil)!))
            shuffleSound?.setVolume(5, fadeDuration: .zero)
        } catch {
            // couldn't load file :(
        }
    }
    
    init(_ cards: [Card?] = [nil, nil, nil, nil]) {
        self.cards = cards
        self.canFlee = true
        self.usedHealthPotion = false
        self.isDealingCards = false
        self.playerFleed = false
        setDestinations()
        initializeSounds()
    }
    
    func reset(deck: Deck) {
        self.usedHealthPotion = false
        cards = [nil, nil, nil, nil]
        isDealingCards = true
        nextRoom(deck: deck, fleedLastRoom: false)
        self.playerFleed = false
    }
    
    func removeCard(at index: Int) {
        withAnimation {
            cards[index] = nil
        }
    }
    
    func flee(deck: Deck) {
        self.isDealingCards = true
        self.playerFleed = true
        destinations = [.deck, .deck, .deck, .deck]
        if !soundEffectsMuted { shuffleSound?.play() }
        
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
        canFlee = !fleedLastRoom
        
        setDestinations()
        var dealingGap: Double = animationDelay
        for i in 0...3 {
            if cards[i] == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + dealingGap) {
                    withAnimation(.spring()) {
                        self.cards[i] = deck.getTopCard()
                        if self.cards[i] != nil && !self.soundEffectsMuted {
                            self.dealCardSounds[i]?.play()
                        }
                        self.setDestinations()
                    }
                }
                dealingGap += animationDelay
            }
            
            if i == 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + dealingGap) {
                    self.isDealingCards = false
                }
            }
        }
        
        usedHealthPotion = false
    }
    
    func finishDealing(deck: Deck) {
        setDestinations()
        for i in 0...3 {
            if cards[i] == nil {
                self.cards[i] = deck.getTopCard()
                self.setDestinations()
            }
        }
        
        self.isDealingCards = false
        usedHealthPotion = false
    }
    
    // Required for Codable protocol conformance
    enum CodingKeys: CodingKey {
        case canFlee
        case cards
        case usedHealthPotion
        case playerFleed
        case isDealingCards
        case destinations
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canFlee = try container.decode(Bool.self, forKey: .canFlee)
        cards = try container.decode([Card?].self, forKey: .cards)
        usedHealthPotion = try container.decode(Bool.self, forKey: .usedHealthPotion)
        playerFleed = try container.decode(Bool.self, forKey: .playerFleed)
        isDealingCards = try container.decode(Bool.self, forKey: .isDealingCards)
        destinations = try container.decode([CardDestination].self, forKey: .destinations)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(canFlee, forKey: .canFlee)
        try container.encode(cards, forKey: .cards)
        try container.encode(usedHealthPotion, forKey: .usedHealthPotion)
        try container.encode(playerFleed, forKey: .playerFleed)
        try container.encode(isDealingCards, forKey: .isDealingCards)
        try container.encode(destinations, forKey: .destinations)
    }
}

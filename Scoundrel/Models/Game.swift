//
//  Game.swift
//  Scoundrel
//
//  Created by David Freeman on 3/8/25.
//

import SwiftUI

class Game: ObservableObject {
    @Published var gameKitHelper: GameKitHelper = GameKitHelper()
    
    @Published var deck: Deck
    @Published var player: Player
    @Published var room: Room
    
    @Published var gameOver: Bool = false
    @Published var score: Int = 0
    @Published var bonusPoints: Int = 0
    @Published var strengthOfMonsterThatKilledPlayer: Int = 0
    @Published var gameOverModalAchievement: GameKitHelper.Achievement? = nil
    
    let lowestPossibleScore: Int = 6 // killed strength 6 monster unarmed, tried to kill strength 14 monster unarmed
    let lowestWinningScore: Int = 209 // killed all monsters with 1 health remaining
    let tenLifeRemainingScore: Int = 218
    let twentyLifeRemainingScore: Int = 228
    let highestPossibleScore: Int = 238
    
    init() {
        self.deck = Deck()
        self.player = Player()
        self.room = Room()
        
        gameKitHelper.authenticateLocalPlayer()
    }
    
    func newGame() {
        score = 0
        bonusPoints = 0
        strengthOfMonsterThatKilledPlayer = 0
        gameOverModalAchievement = nil
        
        player.reset()
        deck.reset()
        room.reset(deck: deck)
        
        withAnimation { gameOver = false }
    }
    
    func equipWeapon(cardIndex: Int) {
        player.equipWeapon(weaponStrength: room.cards[cardIndex]!.strength)
        
        endAction(cardIndex: cardIndex)
    }
    
    func useHealthPotion(cardIndex: Int) {
        if player.health == 20 {
            bonusPoints = room.cards[cardIndex]!.strength
        }
        
        if !room.usedHealthPotion {
            player.useHealthPotion(potionStrength: room.cards[cardIndex]!.strength)
            room.usedHealthPotion = true
        }
        
        endAction(cardIndex: cardIndex)
    }
    
    func attackMonster(cardIndex: Int, attackUnarmed: Bool) {
        // Check for achievements pre-attack
        if !attackUnarmed && player.lastAttacked ?? 0 == 15 && room.cards[cardIndex]!.strength == 2 {
            Task { await gameKitHelper.unlockAchievement(.WhatAWaste) }
        }
        
        // Attack
        if attackUnarmed {
            player.attack(monsterStrength: room.cards[cardIndex]!.strength)
        } else {
            player.attack(withWeapon: true, monsterStrength: room.cards[cardIndex]!.strength)
        }
        
        // Check for achievements post-attack
        if player.health > 0 {
            if player.weapon ?? 0 == 2 && room.cards[cardIndex]!.strength == 14 {
                Task { await gameKitHelper.unlockAchievement(.DavidAndGoliath) }
            }
            withAnimation { score += room.cards[cardIndex]!.strength }
        } else {
            if room.cards[cardIndex]!.strength == 2 {
                Task { await gameKitHelper.unlockAchievement(.DefinitelyMeantToDoThat) }
            }
        }
        
        if player.health <= 0 {
            strengthOfMonsterThatKilledPlayer = room.cards[cardIndex]!.strength
            endGame()
            return
        }
        
        endAction(cardIndex: cardIndex)
    }
    
    func endAction(cardIndex: Int) {
        room.canFlee = false
        
        withAnimation(.spring()) {
            room.removeCard(at: cardIndex)
        }
        
        if room.cards.filter({ $0 == nil }).count == 3 && !deck.cards.isEmpty {
            room.isDealingCards = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.room.nextRoom(deck: self.deck, fleedLastRoom: false)
            }
        }
        
        if deck.cards.isEmpty && room.cards.filter({ $0 == nil }).count == 4 {
            handleDungeonCompletion()
        } else {
            bonusPoints = 0
        }
    }
    
    func handleDungeonCompletion() {
        withAnimation {
            score += player.health
            score += bonusPoints
        }
        
        endGame()
    }
    
    func endGame() {
        checkForAchievements()
        
        withAnimation { gameOver = true }
        
        Task { await gameKitHelper.submitScore(score) }
    }
    
    func checkForAchievements() {
        if score == lowestPossibleScore {
            gameKitHelper.unlockAchievement(.WereYouEvenTrying)
            gameOverModalAchievement = .WereYouEvenTrying
        }
        
        if player.health <= 0 && strengthOfMonsterThatKilledPlayer == 2 {
            gameOverModalAchievement = .DefinitelyMeantToDoThat
        }
        
        if score >= lowestWinningScore {
            gameKitHelper.unlockAchievement(.Survivor)
            gameOverModalAchievement = .Survivor
        }
        
        if score >= tenLifeRemainingScore {
            gameKitHelper.unlockAchievement(.SeasonedAdventurer)
            gameOverModalAchievement = .SeasonedAdventurer
        }
        
        if score >= twentyLifeRemainingScore {
            gameKitHelper.unlockAchievement(.DungeonMaster)
            gameOverModalAchievement = .DungeonMaster
        }
        
        if player.health > 0 && !room.playerFleed {
            gameKitHelper.unlockAchievement(.CowardsNeedNotApply)
            gameOverModalAchievement = .CowardsNeedNotApply
        }
        
        if score == highestPossibleScore {
            gameKitHelper.unlockAchievement(.Untouchable)
            gameOverModalAchievement = .Untouchable
        }
    }
}

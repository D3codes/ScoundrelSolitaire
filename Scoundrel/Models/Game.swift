//
//  Game.swift
//  Scoundrel
//
//  Created by David Freeman on 3/8/25.
//

import SwiftUI
import Combine

class Game: ObservableObject {
    @Published var gameKitHelper: GameKitHelper = GameKitHelper()
    
    @Published var deck: Deck
    @Published var player: Player
    @Published var room: Room
    
    @Published var gameOver: Bool = false
    @Published var score: Int = 0
    @Published var bonusPoints: Int = 0
    @Published var strengthOfMonsterThatKilledPlayer: Int = 0
    @Published var gameOverModalAchievement: GameKitHelper.BinaryAchievement? = nil
    @Published var previousBestScore: Int? = nil
    @Published var dungeonBeat: Bool = false
    
    let lowestPossibleScore: Int = 6 // killed strength 6 monster unarmed, tried to kill strength 14 monster unarmed
//    let lowestWinningScore: Int = 209 // killed all monsters with 1 health remaining
//    let tenLifeRemainingScore: Int = 218
//    let twentyLifeRemainingScore: Int = 228
//    let highestPossibleScore: Int = 238
    
    var deckCancellable: AnyCancellable? = nil
    var playerCancellable: AnyCancellable? = nil
    var roomCancellable: AnyCancellable? = nil
    
    init() {
        self.deck = Deck()
        self.player = Player()
        self.room = Room()
        
        // Required to propagate changes from sub-objects
        deckCancellable = deck.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        playerCancellable = player.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        roomCancellable = room.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        
        gameKitHelper.authenticateLocalPlayer()
    }
    
    func newGame() {
        score = 0
        bonusPoints = 0
        strengthOfMonsterThatKilledPlayer = 0
        gameOverModalAchievement = nil
        previousBestScore = nil
        Task { @MainActor in
            previousBestScore = await gameKitHelper.fetchPlayerScore(leaderboardId: .ScoundrelAllTimeHighScore)?.score ?? nil
        }
        dungeonBeat = false
        
        player.reset()
        deck.reset()
        room.reset(deck: deck)
        
        withAnimation { gameOver = false }
    }
    
    func nextDungeon() {
        gameKitHelper.unlockAchievement(.GoingDeeper)
        
        bonusPoints = 0
        strengthOfMonsterThatKilledPlayer = 0
        gameOverModalAchievement = nil
        
        deck.reset()
        room.reset(deck: deck)
        
        withAnimation { dungeonBeat = false }
    }
    
    func flee() {
        gameKitHelper.incrementAchievementProgress(.MasterOfEvasion, by: 1)
        room.flee(deck: deck)
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
            gameKitHelper.unlockAchievement(.WhatAWaste)
        }
        
        // Attack
        if attackUnarmed {
            player.attack(monsterStrength: room.cards[cardIndex]!.strength)
        } else {
            player.attack(withWeapon: true, monsterStrength: room.cards[cardIndex]!.strength)
        }
        
        // End game if player died
        if player.health <= 0 {
            strengthOfMonsterThatKilledPlayer = room.cards[cardIndex]!.strength
            endGame()
            return
        }
        
        // Check for achievements post-attack
        if player.weapon ?? 0 == 2 && room.cards[cardIndex]!.strength == 14 {
            gameKitHelper.unlockAchievement(.DavidAndGoliath)
        }
        
        withAnimation { score += room.cards[cardIndex]!.strength }
        
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
        
        checkForAchievements()
        
        withAnimation { dungeonBeat = true }
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
            gameKitHelper.unlockAchievement(.DefinitelyMeantToDoThat)
            gameOverModalAchievement = .DefinitelyMeantToDoThat
        }
        
        if player.health > 0 {
            gameKitHelper.unlockAchievement(.Survivor)
            gameOverModalAchievement = .Survivor
        }
        
        if player.health == 1 {
            gameKitHelper.unlockAchievement(.HangingByAThread)
            gameOverModalAchievement = .HangingByAThread
        }
        
        if player.health >= 10 {
            gameKitHelper.unlockAchievement(.SeasonedAdventurer)
            gameOverModalAchievement = .SeasonedAdventurer
        }
        
        if player.health == 20 || bonusPoints > 0 {
            gameKitHelper.unlockAchievement(.DungeonMaster)
            gameOverModalAchievement = .DungeonMaster
        }
        
        if player.health > 0 && !room.playerFleed {
            gameKitHelper.unlockAchievement(.CowardsNeedNotApply)
            gameOverModalAchievement = .CowardsNeedNotApply
        }
        
        if bonusPoints == 10 {
            gameKitHelper.unlockAchievement(.Untouchable)
            gameOverModalAchievement = .Untouchable
        }
    }
}

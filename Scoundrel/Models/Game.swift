//
//  Game.swift
//  Scoundrel
//
//  Created by David Freeman on 3/8/25.
//

import SwiftUI
import Combine

class Game: ObservableObject, Codable {
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
    @Published var dungeonDepth: Int = 0
    
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
        
        if let savedGame = UserDefaults.standard.object(forKey: UserDefaultsKeys().game) as? Data {
            let decoder = JSONDecoder()
            if let loadedGame = try? decoder.decode(Game.self, from: savedGame) {
                self.deck = loadedGame.deck
                self.player = loadedGame.player
                self.room = loadedGame.room
                room.initializeSounds()
                if room.isDealingCards {
                    room.finishDealing(deck: deck)
                }
                
                self.gameOver = loadedGame.gameOver
                self.score = loadedGame.score
                self.bonusPoints = loadedGame.bonusPoints
                self.strengthOfMonsterThatKilledPlayer = loadedGame.strengthOfMonsterThatKilledPlayer
                self.gameOverModalAchievement = loadedGame.gameOverModalAchievement
                self.previousBestScore = loadedGame.previousBestScore
                self.dungeonBeat = loadedGame.dungeonBeat
                self.dungeonDepth = loadedGame.dungeonDepth
            }
        }
        
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
        dungeonDepth = 0
        
        player.reset()
        deck.reset()
        room.reset(deck: deck)
        
        withAnimation { gameOver = false }
    }
    
    func nextDungeon() {
        dungeonDepth += 1
        
        switch dungeonDepth {
        case 1: // Entering 2nd Dungeon
            gameKitHelper.unlockAchievement(.GoingDeeper)
            break
        case 2: // Entering 3rd Dungeon
            gameKitHelper.unlockAchievement(.NoTurningBack)
            break
        case 3: // Entering 4th Dungeon
            gameKitHelper.unlockAchievement(.DepthsUncharted)
            break
        case 4: // Entering 5th Dungeon
            gameKitHelper.unlockAchievement(.EndlessDescent)
            break
        default:
            break
        }
        
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
        
        gameKitHelper.incrementAchievementProgress(.DarknessBeckons, by: 4)
        gameKitHelper.incrementAchievementProgress(.SeasonedDelver, by: 2)
        gameKitHelper.incrementAchievementProgress(.MasterOfTheMaze, by: 1.333)
        gameKitHelper.incrementAchievementProgress(.UntoldTrials100Triumphs, by: 1)
        
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
    
    // Required for Codable protocol conformance
    enum CodingKeys: CodingKey {
        case deck
        case player
        case room
        case gameOver
        case score
        case bonusPoints
        case strengthOfMonsterThatKilledPlayer
        case gameOverModalAchievement
        case previousBestScore
        case dungeonBeat
        case dungeonDepth
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deck = try container.decode(Deck.self, forKey: .deck)
        player = try container.decode(Player.self, forKey: .player)
        room = try container.decode(Room.self, forKey: .room)
        gameOver = try container.decode(Bool.self, forKey: .gameOver)
        score = try container.decode(Int.self, forKey: .score)
        bonusPoints = try container.decode(Int.self, forKey: .bonusPoints)
        strengthOfMonsterThatKilledPlayer = try container.decode(Int.self, forKey: .strengthOfMonsterThatKilledPlayer)
        gameOverModalAchievement = try container.decode(GameKitHelper.BinaryAchievement?.self, forKey: .gameOverModalAchievement)
        previousBestScore = try container.decode(Int?.self, forKey: .previousBestScore)
        dungeonBeat = try container.decode(Bool.self, forKey: .dungeonBeat)
        dungeonDepth = try container.decode(Int.self, forKey: .dungeonDepth)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(player, forKey: .player)
        try container.encode(room, forKey: .room)
        try container.encode(gameOver, forKey: .gameOver)
        try container.encode(score, forKey: .score)
        try container.encode(bonusPoints, forKey: .bonusPoints)
        try container.encode(strengthOfMonsterThatKilledPlayer, forKey: .strengthOfMonsterThatKilledPlayer)
        try container.encode(gameOverModalAchievement, forKey: .gameOverModalAchievement)
        try container.encode(previousBestScore, forKey: .previousBestScore)
        try container.encode(dungeonBeat, forKey: .dungeonBeat)
        try container.encode(dungeonDepth, forKey: .dungeonDepth)
    }
}

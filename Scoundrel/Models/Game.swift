//
//  Game.swift
//  Scoundrel
//
//  Created by David Freeman on 3/8/25.
//

import SwiftUI
import Combine
import AVFoundation

class Game: ObservableObject, Codable {
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    let ubiquitousHelper = UbiquitousHelper()
    
    @Published var gameKitHelper: GameKitHelper = GameKitHelper()
    
    @Published var deck: Deck
    @Published var player: Player
    @Published var room: Room
    
    @Published var score: Int = 0
    @Published var bonusPoints: Int = 0
    @Published var strengthOfMonsterThatKilledPlayer: Int = 0
    @Published var gameOverModalAchievement: GameKitHelper.BinaryAchievement? = nil
    @Published var previousBestScore: Int? = nil
    @Published var dungeonDepth: Int = 0
    
    @Published var gameState: GameState = .Created
    enum GameState: String, CaseIterable, Codable {
        case Created
        case Playing
        case Paused
        case DungeonBeat
        case GameOver
    }
    
    let lowestPossibleScore: Int = 6 // killed strength 6 monster unarmed, tried to kill strength 14 monster unarmed
    
    var deckCancellable: AnyCancellable? = nil
    var playerCancellable: AnyCancellable? = nil
    var roomCancellable: AnyCancellable? = nil
    
    var healthPotionSounds: [AVAudioPlayer?] = [nil, nil]
    var glassBreakingSound: AVAudioPlayer?
    var equipWeaponSounds: [AVAudioPlayer?] = [nil, nil]
    var attackWithWeaponSounds: [AVAudioPlayer?] = [nil, nil, nil, nil]
    var attackUnarmedSounds: [AVAudioPlayer?] = [nil, nil, nil, nil, nil]
    var dungeonBeatSound: AVAudioPlayer?
    var gameOverSound: AVAudioPlayer?
    
    func initializeSounds() {
        do {
            healthPotionSounds[0] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sparkle.mp3", ofType:nil)!))
            healthPotionSounds[0]?.setVolume(3, fadeDuration: .zero)
            healthPotionSounds[1] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sparkle2.mp3", ofType:nil)!))
            healthPotionSounds[1]?.setVolume(2, fadeDuration: .zero)
            
            glassBreakingSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "glassbreaking.m4a", ofType:nil)!))
            glassBreakingSound?.setVolume(3, fadeDuration: .zero)
            
            equipWeaponSounds[0] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "equip.mp3", ofType:nil)!))
            equipWeaponSounds[0]?.setVolume(3, fadeDuration: .zero)
            equipWeaponSounds[1] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "equip2.mp3", ofType:nil)!))
            equipWeaponSounds[1]?.setVolume(3, fadeDuration: .zero)
            
            attackWithWeaponSounds[0] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sword1.mp3", ofType:nil)!))
            attackWithWeaponSounds[0]?.setVolume(3, fadeDuration: .zero)
            attackWithWeaponSounds[1] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sword2.mp3", ofType:nil)!))
            attackWithWeaponSounds[1]?.setVolume(3, fadeDuration: .zero)
            attackWithWeaponSounds[2] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sword3.mp3", ofType:nil)!))
            attackWithWeaponSounds[2]?.setVolume(3, fadeDuration: .zero)
            attackWithWeaponSounds[3] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sword4.mp3", ofType:nil)!))
            attackWithWeaponSounds[3]?.setVolume(3, fadeDuration: .zero)
            
            attackUnarmedSounds[0] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "punch1.mp3", ofType:nil)!))
            attackUnarmedSounds[0]?.setVolume(3, fadeDuration: .zero)
            attackUnarmedSounds[1] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "punch2.mp3", ofType:nil)!))
            attackUnarmedSounds[1]?.setVolume(3, fadeDuration: .zero)
            attackUnarmedSounds[2] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "punch3.mp3", ofType:nil)!))
            attackUnarmedSounds[2]?.setVolume(3, fadeDuration: .zero)
            attackUnarmedSounds[3] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "punch4.mp3", ofType:nil)!))
            attackUnarmedSounds[3]?.setVolume(3, fadeDuration: .zero)
            attackUnarmedSounds[4] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "punch5.mp3", ofType:nil)!))
            attackUnarmedSounds[4]?.setVolume(3, fadeDuration: .zero)
            
            dungeonBeatSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "brassfanfare.mp3", ofType:nil)!))
            dungeonBeatSound?.setVolume(5, fadeDuration: .zero)
            
            gameOverSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "gameover.mp3", ofType:nil)!))
            gameOverSound?.setVolume(5, fadeDuration: .zero)
        } catch {
            // couldn't load file :(
        }
    }
    
    init() {
        self.deck = Deck()
        self.player = Player()
        self.room = Room()
        
        initializeSounds()
        
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
                
                self.score = loadedGame.score
                self.bonusPoints = loadedGame.bonusPoints
                self.strengthOfMonsterThatKilledPlayer = loadedGame.strengthOfMonsterThatKilledPlayer
                self.gameOverModalAchievement = loadedGame.gameOverModalAchievement
                self.previousBestScore = loadedGame.previousBestScore
                self.dungeonDepth = loadedGame.dungeonDepth
                self.gameState = loadedGame.gameState
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
        dungeonDepth = 0
        
        player.reset()
        deck.reset()
        room.reset(deck: deck)
        
        withAnimation { gameState = .Playing }
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
        
        withAnimation { gameState = .Playing }
    }
    
    func flee() {
        ubiquitousHelper.incrementUbiquitousValue(for: .NumberOfRoomsFled, by: 1)
        gameKitHelper.incrementAchievementProgress(.MasterOfEvasion, by: 1)
        room.flee(deck: deck)
    }
    
    func equipWeapon(cardIndex: Int) {
        if !soundEffectsMuted { equipWeaponSounds.randomElement()??.play() }
        
        player.equipWeapon(weaponStrength: room.cards[cardIndex]!.strength)
        
        endAction(cardIndex: cardIndex)
    }
    
    func useHealthPotion(cardIndex: Int) {
        if player.health == 20 {
            bonusPoints = room.cards[cardIndex]!.strength
        }
        
        if !room.usedHealthPotion {
            if !soundEffectsMuted { healthPotionSounds.randomElement()??.play() }
            player.useHealthPotion(potionStrength: room.cards[cardIndex]!.strength)
            room.usedHealthPotion = true
        } else {
            if !soundEffectsMuted { glassBreakingSound?.play() }
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
            if !soundEffectsMuted { attackUnarmedSounds.randomElement()??.play() }
            player.attack(monsterStrength: room.cards[cardIndex]!.strength)
        } else {
            if !soundEffectsMuted { attackWithWeaponSounds.randomElement()??.play() }
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
        
        if !soundEffectsMuted { dungeonBeatSound?.play() }
        
        ubiquitousHelper.incrementUbiquitousValue(for: .NumberOfDungeonsBeaten, by: 1)
        
        gameKitHelper.incrementAchievementProgress(.DarknessBeckons, by: 4)
        gameKitHelper.incrementAchievementProgress(.SeasonedDelver, by: 2)
        gameKitHelper.incrementAchievementProgress(.MasterOfTheMaze, by: 1.333)
        gameKitHelper.incrementAchievementProgress(.UntoldTrials100Triumphs, by: 1)
        
        checkForAchievements()
        
        withAnimation { gameState = .DungeonBeat }
    }
    
    func endGame() {
        checkForAchievements()
        
        withAnimation { gameState = .GameOver }
        
        if !soundEffectsMuted { gameOverSound?.play() }
        
        ubiquitousHelper.incrementGameCountAndRecalculateAverageAndHighScores(newScore: score, gameAbandoned: false)
        gameKitHelper.submitScore(score)
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
        case score
        case bonusPoints
        case strengthOfMonsterThatKilledPlayer
        case gameOverModalAchievement
        case previousBestScore
        case dungeonDepth
        case gameState
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deck = try container.decode(Deck.self, forKey: .deck)
        player = try container.decode(Player.self, forKey: .player)
        room = try container.decode(Room.self, forKey: .room)
        score = try container.decode(Int.self, forKey: .score)
        bonusPoints = try container.decode(Int.self, forKey: .bonusPoints)
        strengthOfMonsterThatKilledPlayer = try container.decode(Int.self, forKey: .strengthOfMonsterThatKilledPlayer)
        gameOverModalAchievement = try container.decode(GameKitHelper.BinaryAchievement?.self, forKey: .gameOverModalAchievement)
        previousBestScore = try container.decode(Int?.self, forKey: .previousBestScore)
        dungeonDepth = try container.decode(Int.self, forKey: .dungeonDepth)
        gameState = try container.decode(GameState.self, forKey: .gameState)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(player, forKey: .player)
        try container.encode(room, forKey: .room)
        try container.encode(score, forKey: .score)
        try container.encode(bonusPoints, forKey: .bonusPoints)
        try container.encode(strengthOfMonsterThatKilledPlayer, forKey: .strengthOfMonsterThatKilledPlayer)
        try container.encode(gameOverModalAchievement, forKey: .gameOverModalAchievement)
        try container.encode(previousBestScore, forKey: .previousBestScore)
        try container.encode(dungeonDepth, forKey: .dungeonDepth)
        try container.encode(gameState, forKey: .gameState)
    }
}

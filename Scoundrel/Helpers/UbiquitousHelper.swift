//
//  UbiquitousHelper.swift
//  Scoundrel
//
//  Created by David Freeman on 3/24/25.
//

import Foundation

class UbiquitousHelper {
    enum UbiquitousKey: String, CaseIterable, Codable {
        case NumberOfGamesPlayed
        case NumberOfDungeonsBeaten
        case NumberOfRoomsFled
        case AverageScore
    }
    
    let store = NSUbiquitousKeyValueStore.default
    
    func getUbiquitousValue(for key: UbiquitousKey) -> Int64 {
        return store.longLong(forKey: key.rawValue)
    }
    
    func setUbiquitousValue(_ value: Int64, for key: UbiquitousKey) {
        store.set(value, forKey: key.rawValue)
    }
    
    func incrementUbiquitousValue(for key: UbiquitousKey, by incrementAmount: Int) {
        let previousValue = store.longLong(forKey: key.rawValue)
        store.set(previousValue + Int64(incrementAmount), forKey: key.rawValue)
    }
    
    func incrementGameCountAndRecalculateAverageScore(newScore: Int) {
        let gameCount = getUbiquitousValue(for: .NumberOfGamesPlayed)
        let averageScore = getUbiquitousValue(for: .AverageScore)
        
        let newAverageScore = (averageScore * gameCount + Int64(newScore)) / (gameCount + 1)
        
        setUbiquitousValue(newAverageScore, for: .AverageScore)
        setUbiquitousValue(gameCount + 1, for: .NumberOfGamesPlayed)
    }
}

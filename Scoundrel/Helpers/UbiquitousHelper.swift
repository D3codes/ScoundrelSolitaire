//
//  UbiquitousHelper.swift
//  Scoundrel
//
//  Created by David Freeman on 3/24/25.
//

import Foundation

class UbiquitousHelper {
    enum UbiquitousKey: String, CaseIterable, Codable {
        case NumberOfGamesPlayed // Not used any more. Just use NumberOfGamesCompleted + NumberOfGamesAbandoned
        case NumberOfDungeonsBeaten
        case NumberOfRoomsFled
        case AverageScore
        case HighScore
        case NumberOfGamesCompleted
        case NumberOfGamesAbandoned
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
    
    func incrementGameCountAndRecalculateAverageAndHighScores(newScore: Int, gameAbandoned: Bool) {
        let gamesCompletedCount = getUbiquitousValue(for: .NumberOfGamesCompleted)
        let gamesAbandonedCount = getUbiquitousValue(for: .NumberOfGamesAbandoned)
        let totalGamesCount = gamesCompletedCount + gamesAbandonedCount
        let averageScore = getUbiquitousValue(for: .AverageScore)
        let highScore = getUbiquitousValue(for: .HighScore)
        
        if newScore > Int(highScore) {
            setUbiquitousValue(Int64(newScore), for: .HighScore)
        }
        
        let newAverageScore = (averageScore * totalGamesCount + Int64(newScore)) / (totalGamesCount + 1)
        setUbiquitousValue(newAverageScore, for: .AverageScore)
        
        if gameAbandoned {
            setUbiquitousValue(gamesAbandonedCount + 1, for: .NumberOfGamesAbandoned)
        } else {
            setUbiquitousValue(gamesCompletedCount + 1, for: .NumberOfGamesCompleted)
        }
    }
}

//
//  GameKitHelper.swift
//  Scoundrel
//
//  Created by David Freeman on 3/2/25.
//

import GameKit

class GameKitHelper: GKGameCenterViewController, GKGameCenterControllerDelegate, ObservableObject {
    
    enum Leaderboard: String, CaseIterable {
        case ScoundrelAllTimeHighScore
    }
    
    enum Achievement: String, CaseIterable {
        case DavidAndGoliath
        case WhatAWaste
        case WereYouEvenTrying
        case DefinitelyMeantToDoThat
        case CowardsNeedNotApply
        case Survivor
        case SeasonedAdventurer
        case DungeonMaster
        case Untouchable
        case HangingByAThread
        case MasterOfEvasion
    }
    
    @Published var localPlayerIsAuthenticated: Bool = false
    
    func authenticateLocalPlayer() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            // Present the view controller so the player can sign in.
            if viewController != nil { return }
            
            if error != nil {
                // Player could not be authenticated.
                // Disable Game Center.
                self.localPlayerIsAuthenticated = false
                return
            }
            
            // Player was successfully authenticated.
            self.localPlayerIsAuthenticated = true
            
            // Check if there are any player restrictions before starting the game.
            if GKLocalPlayer.local.isUnderage { /* Hide explicit game content. */ }
            if GKLocalPlayer.local.isMultiplayerGamingRestricted { /* Disable multiplayer game features. */ }
            if GKLocalPlayer.local.isPersonalizedCommunicationRestricted { /* Disable in game communication UI. */ }
            
            GKAccessPoint.shared.showHighlights = true
        }
    }
    
    func showAccessPoint() {
        if localPlayerIsAuthenticated {
            GKAccessPoint.shared.location = .topTrailing
        } else {
            if #available(iOS 18, *) { // Access point is too large on older OS versions
                GKAccessPoint.shared.location = .topTrailing
            } else {
                GKAccessPoint.shared.location = .bottomTrailing
            }
        }
        
        GKAccessPoint.shared.isActive = true
    }
    
    func hideAccessPoint() {
        GKAccessPoint.shared.isActive = false
    }
    
    @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
//    func displayDashboard() {
//        let viewController = GKGameCenterViewController(state: .dashboard)
//        viewController.gameCenterDelegate = self
//        present(viewController, animated: true, completion: nil)
//    }
//    
//    func displayLeaderboards() {
//        let viewController = GKGameCenterViewController(state: .achievements)
//        viewController.gameCenterDelegate = self
//        present(viewController, animated: true, completion: nil)
//    }
//
//    func fetchAchievements() async throws -> [GKAchievement] {
//        if !localPlayerIsAuthenticated { return [] }
//
//        return try await GKAchievement.loadAchievements()
//    }
    
    func submitScore(_ score: Int) async {
        if !localPlayerIsAuthenticated { return }
        
        do {
            try await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [Leaderboard.ScoundrelAllTimeHighScore.rawValue])
        } catch {
            
        }
    }
    
    func fetchLeaderboard(id: String, count: Int) async throws -> [GKLeaderboard.Entry] {
        if !localPlayerIsAuthenticated { return [] }
        
        let leaderboard = try await GKLeaderboard.loadLeaderboards(IDs: [id]).first
        return try await leaderboard?.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...count)).1 ?? []
    }
    
    func incrementAchievementProgress(_ achievementId: Achievement, by incrementAmount: Double) {
        if !localPlayerIsAuthenticated { return }
        
        Task {
            do {
                // Load the player's active achievements.
                let achievements = try await GKAchievement.loadAchievements()
                
                // Find an existing achievement.
                var achievement = achievements.first(where: { $0.identifier == achievementId.rawValue })

                // Otherwise, create a new achievement.
                if achievement == nil {
                    achievement = GKAchievement(identifier: achievementId.rawValue)
                }
                
                achievement!.percentComplete = achievement!.percentComplete + incrementAmount
                      
                // Report the progress to Game Center.
                try await GKAchievement.report([achievement!])
            } catch {
                
            }
        }
    }
    
    func unlockAchievement(_ achievementId: Achievement) {
        if !localPlayerIsAuthenticated { return }
        
        let achievement = GKAchievement(identifier: achievementId.rawValue)
        achievement.percentComplete = 100
        Task {
            do {
                try await GKAchievement.report([achievement])
            } catch {
                
            }
        }
    }
}

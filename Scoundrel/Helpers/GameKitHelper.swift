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
            
            GKAccessPoint.shared.location = .topTrailing
            GKAccessPoint.shared.showHighlights = true
        }
    }
    
    func showAccessPoint() {
        GKAccessPoint.shared.isActive = true
    }
    
    func hideAccessPoint() {
        GKAccessPoint.shared.isActive = false
    }
    
    @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
    func displayDashboard() {
        let viewController = GKGameCenterViewController(state: .dashboard)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func displayLeaderboards() {
        let viewController = GKGameCenterViewController(state: .achievements)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func submitScore(_ score: Int) async throws {
        if !localPlayerIsAuthenticated { return }
        
        try await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [Leaderboard.ScoundrelAllTimeHighScore.rawValue])
    }
    
    func fetchLeaderboard(id: String, count: Int) async throws -> [GKLeaderboard.Entry] {
        if !localPlayerIsAuthenticated { return [] }
        
        let leaderboard = try await GKLeaderboard.loadLeaderboards(IDs: [Leaderboard.ScoundrelAllTimeHighScore.rawValue]).first
        return try await leaderboard?.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...10)).1 ?? []
    }
    
    func fetchAchievements() async throws -> [GKAchievement] {
        if !localPlayerIsAuthenticated { return [] }
        
        return try await GKAchievement.loadAchievements()
    }
    
    func unlockAchievement(_ achievementId: Achievement) async {
        if !localPlayerIsAuthenticated { return }
        
        let achievement = GKAchievement(identifier: achievementId.rawValue)
        achievement.percentComplete = 100
        do {
            try await GKAchievement.report([achievement])
        } catch {
            
        }
    }
}

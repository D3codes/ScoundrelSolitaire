//
//  GameKitHelper.swift
//  Scoundrel
//
//  Created by David Freeman on 3/2/25.
//

import GameKit

class GameKitHelper: GKGameCenterViewController, GKGameCenterControllerDelegate, ObservableObject {
    @Published var localPlayerIsAuthenticated: Bool = false
    
    @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("close game center")
    }
    
    func displayLeaderboards() {
        let viewController = GKGameCenterViewController(state: .achievements)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func submitScore(_ score: Int) async throws {
        try await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["ScoundrelAllTimeHighScore"])
    }
    
    func fetchLeaderboard(id: String, count: Int) async throws -> [GKLeaderboard.Entry] {
        let leaderboard = try await GKLeaderboard.loadLeaderboards(IDs: ["ScoundrelAllTimeHighScore"]).first
        return try await leaderboard?.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...10)).1 ?? []
    }
}

//
//  LeaderboardView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/3/25.
//

import SwiftUI
import GameKit

struct LeaderboardView: View {
    @ObservedObject var gameKitHelper: GameKitHelper
    
    @State private var leaderboardEntries: [GKLeaderboard.Entry] = []

    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Leaderboard")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding(.top)
                Text("(All Time)")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                if !leaderboardEntries.isEmpty {
                    List(leaderboardEntries, id: \.player.gamePlayerID) { entry in
                        HStack {
                            Text("\(entry.player.displayName)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(entry.formattedScore)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    Spacer()
                    Text("Loading...")
                        .font(.custom("ModernAntiqua-Regular", size: 20))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                    Spacer()
                }
            }
        }
        .task {
            do {
                leaderboardEntries = try await gameKitHelper.fetchLeaderboard(id: "ScoundrelAllTimeHighScore", count: 100)
            } catch {
                print("Failed to fetch leaderboard: \(error)")
            }
        }
    }
}

#Preview {
    struct LeaderboardView_Preview: View {
        @StateObject var gameKitHelper = GameKitHelper()
        
        var body: some View {
            LeaderboardView(gameKitHelper: gameKitHelper)
        }
    }
    
    return LeaderboardView_Preview()
}

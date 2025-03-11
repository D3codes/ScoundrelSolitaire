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

    func fetchLeaderboardEntries() async {
        do {
            leaderboardEntries = try await gameKitHelper.fetchLeaderboard(.ScoundrelAllTimeHighScore, top: 100)
        } catch {
            // Failed to fetch leaderboard
        }
    }
    
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
                    .font(.custom("ModernAntiqua-Regular", size: 30))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                if !leaderboardEntries.isEmpty {
                    List(leaderboardEntries.indices, id: \.self) { index in
                        HStack {
                            if index == 0 {
                                Image("goldMedal")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            } else if index == 1 {
                                Image("silverMedal")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            } else if index == 2 {
                                Image("bronzeMedal")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            } else {
                                Text("\(index+1).")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                            }
                            Text("\(leaderboardEntries[index].player.displayName)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            
                            Spacer()
                            Text("\(leaderboardEntries[index].formattedScore)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.ultraThinMaterial)
                            .frame(width: 150, height: 100)
                        
                        VStack {
                            ProgressView()
                            Text("Loading...")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                    }
                    Spacer()
                    Spacer()
                }
            }
        }
        .task { await fetchLeaderboardEntries() }
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

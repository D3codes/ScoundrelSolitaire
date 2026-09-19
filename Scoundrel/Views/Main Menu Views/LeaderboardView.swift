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
    @EnvironmentObject private var controllerInput: ControllerInputMonitor
    
    @State private var leaderboardEntries: [GKLeaderboard.Entry] = []
    @State private var playerEntry: GKLeaderboard.Entry? = nil
    @State private var controllerScrollTarget = 0
    
    func fetchLeaderboardEntries() async {
        leaderboardEntries = await gameKitHelper.fetchLeaderboard(.ScoundrelAllTimeHighScore, top: 100)
        playerEntry = await gameKitHelper.fetchPlayerScore(leaderboardId: .ScoundrelAllTimeHighScore)
    }
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Top 100")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding(.top)
                Text("(All Time)")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                if !leaderboardEntries.isEmpty {
                    ScrollViewReader { proxy in
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
                            VStack {
                                Text("\(leaderboardEntries[index].player.displayName)")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if leaderboardEntries[index].player.displayName == playerEntry?.player.displayName {
                                    Text("You")
                                        .font(.custom("ModernAntiqua-Regular", size: 10))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            Spacer()
                            Text("\(leaderboardEntries[index].score)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(leaderboardEntries[index].player.displayName == playerEntry?.player.displayName ? .regularMaterial : .thinMaterial))
                    }
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                    .onChange(of: controllerInput.occurrence) { _, occurrence in
                        guard controllerInput.isControllerConnected, let occurrence else { return }
                        if occurrence.input == .down {
                            controllerScrollTarget = min(controllerScrollTarget + 5, leaderboardEntries.count - 1)
                        } else if occurrence.input == .up {
                            controllerScrollTarget = max(controllerScrollTarget - 5, 0)
                        } else {
                            return
                        }
                        withAnimation { proxy.scrollTo(controllerScrollTarget, anchor: .center) }
                    }
                    }
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

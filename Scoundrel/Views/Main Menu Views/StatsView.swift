//
//  StatsView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/23/25.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var gameKitHelper: GameKitHelper
    
    let ubiquitousHelper = UbiquitousHelper()
    
    @State var gamesPlayed: Int64 = 0 // Ubiquitous
    @State var dungeonsBeaten: Int64 = 0 // Ubiquitous
    @State var roomsFled: Int64 = 0 // Ubiquitous
    @State var highScore: Int? = nil // Game Center
    @State var averageScore: Int64 = 0 // Ubiquitous
    @State var leaderboardRank: Int? = nil // Game Center
    @State var achievementsUnlocked: Int? = nil // Game Center
    
    @State var showingHighScorePopover: Bool = false
    @State var showingRankPopover: Bool = false
    @State var showingAchievementsPopover: Bool = false
    
    func fetchStats() {
        gamesPlayed = ubiquitousHelper.getUbiquitousValue(for: .NumberOfGamesPlayed)
        dungeonsBeaten = ubiquitousHelper.getUbiquitousValue(for: .NumberOfDungeonsBeaten)
        roomsFled = ubiquitousHelper.getUbiquitousValue(for: .NumberOfRoomsFled)
        averageScore = ubiquitousHelper.getUbiquitousValue(for: .AverageScore)
        
        Task { @MainActor in
            let roomsFledProgess = Int64(await gameKitHelper.fetchAchievementProgress(for: .MasterOfEvasion))
            if roomsFledProgess > roomsFled {
                roomsFled = roomsFledProgess
                ubiquitousHelper.setUbiquitousValue(roomsFled, for: .NumberOfRoomsFled)
            }
            
            let dungeonsBeatenProgress = Int64(await gameKitHelper.fetchAchievementProgress(for: .UntoldTrials100Triumphs))
            if dungeonsBeatenProgress > dungeonsBeaten {
                dungeonsBeaten = dungeonsBeatenProgress
                ubiquitousHelper.setUbiquitousValue(dungeonsBeaten, for: .NumberOfDungeonsBeaten)
            }
            
            highScore = await gameKitHelper.fetchPlayerScore(leaderboardId: .ScoundrelAllTimeHighScore)?.score
            leaderboardRank = await gameKitHelper.fetchPlayerScore(leaderboardId: .ScoundrelAllTimeHighScore)?.rank
            achievementsUnlocked = await gameKitHelper.fetchCompletedAchievementsCount()
        }
    }
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Stats")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding(.top)
                
                Spacer()
                
                List {
                    Section {
                        HStack {
                            Text("Games Played")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(gamesPlayed)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
                        HStack {
                            Text("Dungeons Beat")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(dungeonsBeaten)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
                        HStack {
                            Text("Rooms Fled")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(roomsFled)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                    }
                    
                    Section {
                        HStack {
                            Text("Average Score")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(averageScore)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
                        HStack {
                            Text("High Score")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                                .foregroundStyle(highScore == nil ? .secondary : .primary)
                            Spacer()
                            if highScore != nil {
                                Text("\(highScore!)")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                            } else {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.teal)
                            }
                        }
                        .listRowBackground(Rectangle().fill(highScore == nil ? .ultraThinMaterial : .thinMaterial))
                        .onTapGesture {
                            if #available(iOS 16.4, *), highScore == nil { // presentationCompactAdaptation not available on older OS versions
                                showingHighScorePopover = true
                            }
                        }
                        .popover(isPresented: $showingHighScorePopover) {
                            if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                                Text("Sign in to Game Center to view High Scores")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.headline)
                                    .padding()
                                    .presentationCompactAdaptation(.popover)
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Leaderboard Rank")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                                .foregroundStyle(leaderboardRank == nil ? .secondary : .primary)
                            Spacer()
                            if leaderboardRank != nil {
                                if leaderboardRank == 1 {
                                    Image("goldMedal")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                } else if leaderboardRank == 2 {
                                    Image("silverMedal")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                } else if leaderboardRank == 3 {
                                    Image("bronzeMedal")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                
                                Text("\(leaderboardRank!)")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                            } else {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.teal)
                            }
                        }
                        .listRowBackground(Rectangle().fill(leaderboardRank == nil ? .ultraThinMaterial : .thinMaterial))
                        .onTapGesture {
                            if #available(iOS 16.4, *), leaderboardRank == nil { // presentationCompactAdaptation not available on older OS versions
                                showingRankPopover = true
                            }
                        }
                        .popover(isPresented: $showingRankPopover) {
                            if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                                Text("Sign in to Game Center to view Rank")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.headline)
                                    .padding()
                                    .presentationCompactAdaptation(.popover)
                            }
                        }
                        
                        HStack {
                            Text("Achievements Unlocked")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                                .foregroundStyle(achievementsUnlocked == nil ? .secondary : .primary)
                            Spacer()
                            if achievementsUnlocked != nil {
                                Text("\(achievementsUnlocked!)")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                            } else {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.teal)
                            }
                            
                        }
                        .listRowBackground(Rectangle().fill(achievementsUnlocked == nil ? .ultraThinMaterial : .thinMaterial))
                        .onTapGesture {
                            if #available(iOS 16.4, *), achievementsUnlocked == nil { // presentationCompactAdaptation not available on older OS versions
                                showingAchievementsPopover = true
                            }
                        }
                        .popover(isPresented: $showingAchievementsPopover) {
                            if #available(iOS 16.4, *) { // presentationCompactAdaptation not available on older OS versions
                                Text("Sign in to Game Center to view Achievements")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.headline)
                                    .padding()
                                    .presentationCompactAdaptation(.popover)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
        }
        .onAppear { fetchStats() }
    }
}

#Preview {
    struct StatsView_Preview: View {
        
        var body: some View {
            StatsView(
                gameKitHelper: GameKitHelper()
            )
        }
    }
    
    return StatsView_Preview()
}

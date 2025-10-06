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
    
    @State var gamesAbandoned: Int64 = 0 // Ubiquitous
    @State var gamesCompleted: Int64 = 0 // Ubiquitous
    @State var dungeonsBeaten: Int64 = 0 // Ubiquitous
    @State var roomsFled: Int64 = 0 // Ubiquitous
    @State var highScore: Int = 0 // Game Center
    @State var averageScore: Int64 = 0 // Ubiquitous
    @State var leaderboardRank: Int? = nil // Game Center
    @State var achievementsUnlocked: Int? = nil // Game Center
    
    @State var showingRankPopover: Bool = false
    @State var showingAchievementsPopover: Bool = false
    
    func fetchStats() {
        gamesAbandoned = ubiquitousHelper.getUbiquitousValue(for: .NumberOfGamesAbandoned)
        gamesCompleted = ubiquitousHelper.getUbiquitousValue(for: .NumberOfGamesCompleted)
        dungeonsBeaten = ubiquitousHelper.getUbiquitousValue(for: .NumberOfDungeonsBeaten)
        roomsFled = ubiquitousHelper.getUbiquitousValue(for: .NumberOfRoomsFled)
        averageScore = ubiquitousHelper.getUbiquitousValue(for: .AverageScore)
        highScore = Int(ubiquitousHelper.getUbiquitousValue(for: .HighScore))
        
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
            
            let gameCenterHighScore = await gameKitHelper.fetchPlayerScore(leaderboardId: .ScoundrelAllTimeHighScore)?.score ?? 0
            if gameCenterHighScore > highScore {
                highScore = gameCenterHighScore
                ubiquitousHelper.setUbiquitousValue(Int64(highScore), for: .HighScore)
            } else if highScore > gameCenterHighScore {
                gameKitHelper.submitScore(highScore)
            }
            
            leaderboardRank = await gameKitHelper.fetchPlayerScore(leaderboardId: .ScoundrelAllTimeHighScore)?.rank
            achievementsUnlocked = await gameKitHelper.fetchCompletedAchievementsCount()
        }
    }
    
    func getSharePreviewTitle() -> String {
        return "Check out my Stats in Scoundrel Solitaire!"
    }
    
    func getGamesStats() -> String {
        return "🃏 Games\nPlayed: \(gamesAbandoned + gamesCompleted)\nAbandoned: \(gamesAbandoned)\nCompleted: \(gamesCompleted)"
    }
    
    func getOtherStats() -> String {
        return "🏰 Stats\nRooms Fled: \(roomsFled)\nDungeons Beat: \(dungeonsBeaten)"
    }
    
    func getScoreStats() -> String {
        return "⚔️ Scores\nAverage Score: \(averageScore)\nHigh Score: \(highScore)"
    }
    
    func getGameCenterStats() -> String {
        if leaderboardRank == nil || achievementsUnlocked == nil {
            return ""
        }
        
        return "🏆 Game Center\nLeaderboard Rank: \(leaderboardRank!)\nAchievements Unlocked: \(achievementsUnlocked!)\n\n"
    }
    
    func getShareItem() -> String {
        return "\(getSharePreviewTitle())\n\n\(getGamesStats())\n\n\(getOtherStats())\n\n\(getScoreStats())\n\n\(getGameCenterStats())https://apps.apple.com/app/id6742526198"
    }
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        
                        ShareLink(item: getShareItem(), preview: SharePreview(
                            getSharePreviewTitle(),
                            image: Image("logo")
                        )) {
                            if #available(iOS 26.0, *) { // glass effect not available on older OS versions
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.teal)
                                    .frame(width: 40, height: 40)
                                    .font(.system(size: 18))
                                    .bold()
                                    .glassEffect(.regular.interactive(), in: .circle)
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(.thinMaterial)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundStyle(.teal)
                                        .font(.system(size: 18))
                                        .bold()
                                }
                            }
                        }
                    }
                    .padding(.trailing, 50)
                    .padding(.top, 10)
                    
                    Text("Stats")
                        .font(.custom("ModernAntiqua-Regular", size: 40))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        .padding(.top)
                }
                
                Spacer()
                
                List {
                    Section {
                        HStack {
                            Text("Games Played")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(gamesAbandoned + gamesCompleted)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
                        HStack {
                            Text("Games Abandoned")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(gamesAbandoned)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
                        HStack {
                            Text("Games Completed")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(gamesCompleted)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                    }
                    
                    Section {
                        HStack {
                            Text("Rooms Fled")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            Spacer()
                            Text("\(roomsFled)")
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
                            Spacer()
                            Text("\(highScore)")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
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

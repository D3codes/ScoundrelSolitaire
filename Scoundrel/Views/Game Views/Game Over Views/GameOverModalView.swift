//
//  GameOverModalView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/24/25.
//

import SwiftUI
import Vortex

struct GameOverModalView: View {
    @ObservedObject var gameKitHelper: GameKitHelper
    
    var score: Int
    var newGame: () -> Void
    var mainMenu: () -> Void
    
    @State var strengthOfMonsterThatKilledPlayer: Int
    
    @State var achievementName: String?
    @State var achievementDescription: String?
    @State var achievementImage: String?
    
    let lowestPossibleScore: Int = 6
    let lowestWinningScore: Int = 209
    let tenLifeRemainingScore: Int = 218
    let twentyLifeRemainingScore: Int = 228
    let highestPossibleScore: Int = 238
    
    
    func checkForAchievements() async {
        if score == lowestPossibleScore {
            await gameKitHelper.unlockAchievement(.WereYouEvenTrying)
            achievementName = "Were You Even Trying?"
            achievementDescription = "Get the lowest possible score"
            achievementImage = "WereYouEvenTrying"
        }
        
        if strengthOfMonsterThatKilledPlayer == 2 {
            achievementName = "Meant To Do That!"
            achievementDescription = "Die from the weakest monster"
            achievementImage = "DefinitelyMeantToDoThat"
        }
        
        if score >= lowestWinningScore {
            await gameKitHelper.unlockAchievement(.Survivor)
            achievementName = "Survivor"
            achievementDescription = "Make it through a dungeon without dying"
            achievementImage = "Survivor"
        }
        
        if score >= tenLifeRemainingScore {
            await gameKitHelper.unlockAchievement(.SeasonedAdventurer)
            achievementName = "Seasoned Adventurer"
            achievementDescription = "Beat a dungeon with at least 10 life remaining"
            achievementImage = "SeasonedAdventurer"
        }
        
        if score >= twentyLifeRemainingScore {
            await gameKitHelper.unlockAchievement(.DungeonMaster)
            achievementName = "Dungeon Master"
            achievementDescription = "Beat a dungeon with at least 20 life remaining"
            achievementImage = "DungeonMaster"
        }
        
        if score == highestPossibleScore {
            await gameKitHelper.unlockAchievement(.Untouchable)
            achievementName = "Untouchable"
            achievementDescription = "Beat a dungeon with the highest possible score"
            achievementImage = "Untouchable"
        }
    }
    
    func submitScoreToGameCenter() async {
        if gameKitHelper.localPlayerIsAuthenticated {
            do {
                try await gameKitHelper.submitScore(score)
            } catch {
                // Failed to submit score
            }
        }
    }
    
    func getSharePreviewTitle() -> String {
        return "I scored \(score) in Scoundrel Solitaire!"
    }
    
    func getShareItem() -> String {
        return "\(getSharePreviewTitle())\nCan you beat me?\nhttps://apps.apple.com/app/id6742526198"
    }
    
    var body: some View {
        ZStack {
            VStack {
                if achievementName != nil {
                    GameOverAchievementView(
                        achievementName: achievementName!,
                        achievementDescription: achievementDescription!,
                        achievementImage: achievementImage!
                    )
                    .zIndex(10)
                }
                
                ZStack {
                    Image("paper")
                        .resizable()
                        .cornerRadius(20)
                    
                    VStack {
                        HStack {
                            Spacer()
                            ShareLink(item: getShareItem(), preview: SharePreview(
                                getSharePreviewTitle(),
                                image: Image("logo")
                            )) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 1)
                        
                        Text("Game Over")
                            .font(.custom("MorrisRoman-Black", size: 50))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            .padding(.bottom, 2)
                        
                        Text("Score: \(score)")
                            .font(.custom("ModernAntiqua-Regular", size: 30))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button(action: { newGame() }, label: {
                            ZStack {
                                Image("plank1")
                                    .resizable()
                                    .frame(width: 200, height: 50)
                                Text("New Game")
                                    .font(.custom("ModernAntiqua-Regular", size: 30))
                                    .foregroundStyle(.white)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                            }
                        })
                        
                        Button(action: { mainMenu() }, label: {
                            ZStack {
                                Image("plank1")
                                    .resizable()
                                    .frame(width: 200, height: 50)
                                Text("Main Menu")
                                    .font(.custom("ModernAntiqua-Regular", size: 30))
                                    .foregroundStyle(.white)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                            }
                        })
                        
                        Spacer()
                    }
                }
                .frame(width: 300, height: 400)
                .task {
                    //await submitScoreToGameCenter()
                    //await checkForAchievements()
                }
            }
            
            if score > lowestWinningScore {
                VortexView(.fireworks) {
                    Circle()
                        .fill(.white)
                        .blendMode(.plusLighter)
                        .frame(width: 32)
                        .tag("circle")
                }
                .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    struct GameOverModalView_Preview: View {
        @StateObject var gameKitHelper = GameKitHelper()
        
        func newGame() { }
        func mainMenu() { }
        
        var body: some View {
            GameOverModalView(
                gameKitHelper: gameKitHelper,
                score: 6,
                newGame: newGame,
                mainMenu: mainMenu,
                strengthOfMonsterThatKilledPlayer: 0
            )
        }
    }
    
    return GameOverModalView_Preview()
}

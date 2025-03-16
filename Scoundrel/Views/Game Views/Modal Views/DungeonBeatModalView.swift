//
//  DungeonBeatModalView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/14/25.
//

import SwiftUI
import Vortex

struct DungeonBeatModalView: View {
    @ObservedObject var game: Game

    var nextDungeon: () -> Void
    
    @State var achievementName: String?
    @State var achievementDescription: String?
    @State var achievementImage: String?
    
    var body: some View {
        ZStack {
            VStack {
                if game.gameOverModalAchievement != nil {
                    AchievementBannerView(achievement: game.gameOverModalAchievement!)
                        .zIndex(10)
                }
                
                ZStack {
                    Image("paper")
                        .resizable()
                        .cornerRadius(20)
                    
                    VStack {
                        Text("Dungeon")
                            .font(.custom("MorrisRoman-Black", size: 50))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            .padding(.top, 40)
                        Text("Cleared!")
                            .font(.custom("MorrisRoman-Black", size: 50))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            .padding(.bottom, 2)
                        
                        HStack {
                            Text("Score:")
                                .font(.custom("ModernAntiqua-Regular", size: 30))
                                .foregroundStyle(.black)
                            Spacer()
                            Text("\(game.score)")
                                .font(.custom("ModernAntiqua-Regular", size: 30))
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 50)
                        HStack {
                            Text("Dungeons:")
                                .font(.custom("ModernAntiqua-Regular", size: 30))
                                .foregroundStyle(.black)
                            Spacer()
                            Text("\(game.dungeonDepth + 1)")
                                .font(.custom("ModernAntiqua-Regular", size: 30))
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 50)
                        
                        Spacer()
                        Spacer()
                        
                        Button(action: { nextDungeon() }, label: {
                            ZStack {
                                Image("plank1")
                                    .resizable()
                                    .frame(width: 225, height: 50)
                                Text("Next Dungeon")
                                    .font(.custom("ModernAntiqua-Regular", size: 30))
                                    .foregroundStyle(.white)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                            }
                        })
                        
                        Spacer()
                    }
                }
                .frame(width: 300, height: 400)
            }
        }
    }
}

#Preview {
    struct DungeonBeatModalView_Preview: View {
        var body: some View {
            DungeonBeatModalView(
                game: Game(),
                nextDungeon: {}
            )
        }
    }
    
    return DungeonBeatModalView_Preview()
}

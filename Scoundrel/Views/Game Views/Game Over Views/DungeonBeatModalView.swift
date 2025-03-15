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
                    GameOverAchievementView(achievement: game.gameOverModalAchievement!)
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
                        
                        Text("Score: \(game.score)")
                            .font(.custom("ModernAntiqua-Regular", size: 30))
                            .foregroundStyle(.black)
                        
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

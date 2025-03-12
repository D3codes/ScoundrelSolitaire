//
//  GameOverModalView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/24/25.
//

import SwiftUI
import Vortex

struct GameOverModalView: View {
    @ObservedObject var game: Game

    var newGame: () -> Void
    var mainMenu: () -> Void
    
    @State var achievementName: String?
    @State var achievementDescription: String?
    @State var achievementImage: String?
    
    func getSharePreviewTitle() -> String {
        return "I scored \(game.score) in Scoundrel Solitaire!"
    }
    
    func getShareItem() -> String {
        return "\(getSharePreviewTitle())\nCan you beat me?\nhttps://apps.apple.com/app/id6742526198"
    }
    
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
                        
                        Text("Score: \(game.score)")
                            .font(.custom("ModernAntiqua-Regular", size: 30))
                            .foregroundStyle(.black)
                        
                        if game.score > game.previousBestScore ?? 0 {
                            Text("New Personal Best!")
                                .font(.custom("ModernAntiqua-Regular", size: 15))
                                .foregroundStyle(.black)
                        }
                        
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
            }
            
            if game.score >= game.lowestWinningScore {
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
        func newGame() { }
        func mainMenu() { }
        
        var body: some View {
            GameOverModalView(
                game: Game(),
                newGame: newGame,
                mainMenu: mainMenu
            )
        }
    }
    
    return GameOverModalView_Preview()
}

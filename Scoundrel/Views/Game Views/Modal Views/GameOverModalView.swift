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
        return "Can you beat my score in Scoundrel Solitaire? 🃏\n⚔️ Score: \(game.score)\n🏰 Dungeons: \(game.dungeonDepth)\nhttps://apps.apple.com/app/id6742526198"
    }
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .cornerRadius(20)
            
            VStack {
//                HStack {
//                    Spacer()
//                    ShareLink(item: getShareItem(), preview: SharePreview(
//                        getSharePreviewTitle(),
//                        image: Image("logo")
//                    )) {
//                        Image(systemName: "square.and.arrow.up")
//                            .foregroundStyle(.teal)
//                            .frame(width: 40, height: 40)
//                            .font(.system(size: 18))
//                            .bold()
//                            .glassEffect(.regular.interactive(), in: .circle)
//                    }
//                }
//                .padding(.top, 20)
//                .padding(.trailing, 20)
//                .padding(.bottom, 1)
                
                HStack {
                    Text("Game Over")
                        .font(.custom("MorrisRoman-Black", size: 45))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                    
                    Spacer()
                    
                    ShareLink(item: getShareItem(), preview: SharePreview(
                        getSharePreviewTitle(),
                        image: Image("logo")
                    )) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.teal)
                            .frame(width: 40, height: 40)
                            .font(.system(size: 18))
                            .bold()
                            .glassEffect(.regular.interactive(), in: .circle)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 15)
                .padding(.horizontal, 20)
                
                
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
                    Text("\(game.dungeonDepth)")
                        .font(.custom("ModernAntiqua-Regular", size: 30))
                        .foregroundStyle(.black)
                }
                .padding(.horizontal, 50)
                
                if game.previousBestScore != nil && game.score > game.previousBestScore! {
                    Text("New Personal Best!")
                        .font(.custom("ModernAntiqua-Regular", size: 20))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                PlankButtonView(text: "Main Menu", action: { mainMenu() })
                
                PlankButtonView(text: "New Game", action: { newGame() })
                
                Spacer()
            }
            
            if game.previousBestScore != nil && game.score > game.previousBestScore! {
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
        .frame(minWidth: 300, maxWidth: 300, maxHeight: 400)
    }
}

#Preview {
    struct GameOverModalView_Preview: View {
        func newGame() { }
        func mainMenu() { }
        
        var game: Game = Game()
        
        var body: some View {
            GameOverModalView(
                game: game,
                newGame: newGame,
                mainMenu: mainMenu
            )
            .onAppear {
                game.previousBestScore = 1
                game.score = 2
            }
        }
    }
    
    return GameOverModalView_Preview()
}

//
//  GameOverModalView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/24/25.
//

import SwiftUI

struct GameOverModalView: View {
    @ObservedObject var gameKitHelper: GameKitHelper
    
    var score: Int
    var newGame: () -> Void
    var mainMenu: () -> Void
    
    func submitScoreToGameCenter() async {
        print("submitting...")
        if gameKitHelper.localPlayerIsAuthenticated {
            print("player is authenticated")
            do {
                try await gameKitHelper.submitScore(score)
                print("score submitted")
            } catch {
                print("Failed to submit score: \(error)")
            }
        }
    }
    
    var body: some View {
        ZStack {
            Group{
                Image("paper")
                    .resizable()
                    .cornerRadius(20)
                
                VStack {
                    Spacer()
                    
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
            .onAppear() { Task { await submitScoreToGameCenter() } }
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
                score: -13,
                newGame: newGame,
                mainMenu: mainMenu
            )
        }
    }
    
    return GameOverModalView_Preview()
}

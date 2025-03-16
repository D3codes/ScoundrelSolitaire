//
//  ResumeButtonView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/15/25.
//

import SwiftUI

struct ResumeButtonView: View {
    @ObservedObject var game: Game
    var resumeGame: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                    VStack(spacing: 0) {
                        Image("deck")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(game.deck.cards.count)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                        
                    VStack(spacing: 0) {
                        Text("Score")
                            .frame(height: 30)
                            .font(.custom("MorrisRoman-Black", size: 20))
                        Text("\(game.score)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
                .frame(width: 50)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                    VStack(spacing: 0) {
                        Image("dungeonGlyph")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(game.dungeonDepth)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
            }
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                    VStack(spacing: 0) {
                        Image("heart1")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(game.player.health)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                    VStack(spacing: 0) {
                        Image("shield1")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(game.player.weapon ?? 0)")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.regularMaterial)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                    
                    VStack(spacing: 0) {
                        Image("sword1")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(game.player.strongestMonsterThatCanBeAttacked())")
                            .font(.custom("MorrisRoman-Black", size: 20))
                            .contentTransition(.numericText())
                    }
                }
            }
        }
        PlankButtonView(text: "Resume", action: resumeGame)
    }
}

#Preview {
    struct ResumeButtonView_Preview: View {
        
        var body: some View {
            ResumeButtonView(
                game: Game(),
                resumeGame: {}
            )
        }
    }
    
    return ResumeButtonView_Preview()
}

//
//  HowToView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct HowToView: View {
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            ScrollView {
                Text("How to Play")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding()
                
                
                Text("Objective")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.black)
                Text("Scoundrel Solitaire is a rogue-like card game. The deck is your dungeon, and rooms are made up of four cards at a time. The goal is to make it through as many dungeons as possible without your life reaching 0.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Gameplay")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.black)
                Text("Each room begins with four cards pulled from the top of the deck.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("You may flee the room if you wish. If you do so, the cards in the room will be placed on the bottom of the deck. You cannot flee two rooms in a row.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("If you choose to face a room, you must interact with three of the four cards in the room to advance. The fourth card will be carried over to the next room.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("If you make it through a dungeon, all the cards are shuffled back into the deck and you continue into the next dugeon with your current life and weapon.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("The game ends when your life reaches 0.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Types of Cards")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.black)
                
                HStack {
                    Image("heart1")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Health Potion")
                        .font(.custom("ModernAntiqua-Regular", size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("Strength: 2-10")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("Count: 9")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• Increase life equal to the Health Potion's strength, up to the max of 20.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• Only works once per room. Drinking a second potion will expend it without increasing your life.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                HStack {
                    Image("sword1")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Weapon")
                        .font(.custom("ModernAntiqua-Regular", size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("Strength: 2-10")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("Count: 9")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• Equip an undamaged weapon and a shield with the strength of the Weapon card.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• Any currently equipped weapons and shields are expended.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                HStack {
                    Image("dragon1")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Monster")
                        .font(.custom("ModernAntiqua-Regular", size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("Strength: 2-14")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("Count: 26")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• Attack unarmed, losing life equal to the strength of the Monster card.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("OR")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                    .padding(.leading, 10)
                Text("• Attack with equipped weapon, losing life equal to the strength of the Monster card minus the strength of your shield.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• The equipped weapon will take damage and will only be able to be used against monsters weaker than the strength of the attacked Monster card.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Scoring")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.black)
                Text("At the end of a dungeon, your score is the sum of the strength of all the Monster cards you defeated plus your remaining life.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("If your life is 20 and your last card was a Health Potion, a bonus is added to your score equal to the strength of that card.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("UI")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.black)
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
                            Text("40")
                                .font(.custom("MorrisRoman-Black", size: 20))
                                .contentTransition(.numericText())
                        }
                    }
                    
                    Text("The number of cards remaining in the deck.")
                        .font(.custom("ModernAntiqua-Regular", size: 15))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom)
                HStack {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 100, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        Text("Flee")
                            .foregroundStyle(.white)
                            .font(.custom("ModernAntiqua-Regular", size: 30))
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }

                    
                    Text("Use this button to flee the current room.")
                        .font(.custom("ModernAntiqua-Regular", size: 15))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom)
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
                            Text("20")
                                .font(.custom("MorrisRoman-Black", size: 20))
                                .contentTransition(.numericText())
                        }
                    }
                    
                    Text("Your life.")
                        .font(.custom("ModernAntiqua-Regular", size: 15))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom)
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.regularMaterial)
                            .shadow(color: .black, radius: 5, x: 2, y: 2)
                        
                        VStack(spacing: 0) {
                            Image("shield1")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("10")
                                .font(.custom("MorrisRoman-Black", size: 20))
                                .contentTransition(.numericText())
                        }
                    }
                    
                    Text("The strength of your equipped shield. This number will be subtracted from the strength of a Monster card when attacking with a weapon.")
                        .font(.custom("ModernAntiqua-Regular", size: 15))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom)
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.regularMaterial)
                            .shadow(color: .black, radius: 5, x: 2, y: 2)
                        
                        VStack(spacing: 0) {
                            Image("sword1")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("14")
                                .font(.custom("MorrisRoman-Black", size: 20))
                                .contentTransition(.numericText())
                        }
                    }
                    
                    Text("The strength of your equipped weapon. This signifies the strongest Monster card you can attack with the weapon.")
                        .font(.custom("ModernAntiqua-Regular", size: 15))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
        }
    }
}


#Preview {
    struct HowToView_Preview: View {
        @State var isPresented: Bool = true
        
        var body: some View {
            HowToView()
        }
    }
    
    return HowToView_Preview()
}

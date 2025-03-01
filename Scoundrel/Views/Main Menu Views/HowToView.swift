//
//  HowToView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct HowToView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ModalView(isPresented: $isPresented) {
            ScrollView {
                Text("How to Play")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding()
                
                
                Text("Objective")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.black)
                Text("Scoundrel Solitaire is a Rogue-like card game. The deck is your dungeon, and rooms are made up of four cards at a time. The goal is to make it through the dungeon without your life reaching 0.")
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
                Text("• Equip a weapon and shield both with the strength of the Weapon card.")
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
                Text("• The equipped weapon will take damage and will only be able to be used against monsters weaker than the strength of the Monster card.")
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
                    .padding(.bottom)
                
                Text("Scoring")
                    .font(.custom("ModernAntiqua-Regular", size: 25))
                    .foregroundStyle(.black)
                Text("If your life has reached zero, your score is a negative value determined by subtracting the sum of all remaining monsters in the deck from 0.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                Text("If you have made your way through the enitre deck, your score is your remaining life. If your life is 20 and your last card was a Health Potion, your score is 20 plus the strength of that potion.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
            }
            .padding()
        }
    }
}


#Preview {
    struct HowToView_Preview: View {
        @State var isPresented: Bool = true
        
        var body: some View {
            HowToView(isPresented: $isPresented)
        }
    }
    
    return HowToView_Preview()
}

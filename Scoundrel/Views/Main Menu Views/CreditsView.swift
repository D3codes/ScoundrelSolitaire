//
//  CreditsView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            ScrollView {
                Text("Credits")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding()
                
                
                Text("Created by David Freeman")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                    .padding(.bottom)
                
                Text("Inspiration")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("Inspired by the Scoundrel card game designed by Zach Gage and Kurt Bieg.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Assets")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("Assets and textures were created using ChatGPT / DALL•E.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Icons")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("Icons were created with Genmoji.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Music")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("Music was created with Suno.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Sound Effects")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("Sound effects were created with Infinity SFX.")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Fonts")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("Modern Antiqua - by Wojciech Kalinowski")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("Morris Roman Black - by Dieter Steffmann")
                    .font(.custom("MorrisRoman-Black", size: 18))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Packages")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("Vortex - by Paul Hudson")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Text("Testers")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.black)
                Text("• Cody")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• Elizabeth")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• James")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                Text("• Matt")
                    .font(.custom("ModernAntiqua-Regular", size: 15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
        }
    }
}


#Preview {
    struct CreditsView_Preview: View {
        
        var body: some View {
            CreditsView()
        }
    }
    
    return CreditsView_Preview()
}

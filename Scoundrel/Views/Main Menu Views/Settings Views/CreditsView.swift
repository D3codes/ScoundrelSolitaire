//
//  CreditsView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        Text("Created by [David Freeman](https://d3.codes/about)")
            .font(.custom("ModernAntiqua-Regular", size: 20))
            .frame(maxWidth: .infinity, alignment: .leading)
            .tint(.teal)
        
        VStack {
            Text("Inspiration")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Inspired by the Scoundrel card game designed by Zach Gage and Kurt Bieg.")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack {
            Text("Assets")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Assets and textures were created using ChatGPT / DALL•E.")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack {
            Text("Icons")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Icons were created with Genmoji.")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack {
            Text("Music")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Music was created with Suno.")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack {
            Text("Sound Effects")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Sound effects were created with Infinity SFX.")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack {
            Text("Fonts")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Modern Antiqua - by Wojciech Kalinowski")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Morris Roman Black - by Dieter Steffmann")
                .font(.custom("MorrisRoman-Black", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack {
            Text("Packages")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Vortex - by Paul Hudson")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack {
            Text("Testers")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Cody")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Elizabeth")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• James")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Matt")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
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

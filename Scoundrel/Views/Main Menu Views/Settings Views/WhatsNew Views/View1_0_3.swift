//
//  View1_0_3.swift
//  Scoundrel
//
//  Created by David Freeman on 3/24/25.
//

import SwiftUI

struct View1_0_3: View {
    var body: some View {
        VStack {
            Text("1.0.3")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Endless Gameplay!")
                .font(.custom("ModernAntiqua-Regular", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• The game doesn't end when you beat a dungeon, instead you continue into a new dungeon with your current life, weapon, and score")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Earn achievements the deeper you go!")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text("Save and Resume")
                .font(.custom("ModernAntiqua-Regular", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Progress is now remembered between sessions")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text("Settings")
                .font(.custom("ModernAntiqua-Regular", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Controls to turn on or off background music, sound effects, and haptic feedback")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• New background music added!")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text("Bug Fixes")
                .font(.custom("ModernAntiqua-Regular", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Fixed bug that could cause the game over modal to hang when earning an achievement")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    View1_0_3()
}

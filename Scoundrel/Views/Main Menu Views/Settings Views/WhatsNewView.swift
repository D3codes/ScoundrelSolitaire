//
//  WhatsNewView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/21/25.
//

import SwiftUI

struct WhatsNewView: View {
    
    var body: some View {
        VStack {
            Text("1.1.0")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("...")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("...")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("...")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("...")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
        }
        
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
        
        VStack {
            Text("1.0.2")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("• New achievements!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Running score is now displayed during gameplay")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Leaderboard now highlights player")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Leaderboard recognizes top 3 scores")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Added more dungeon backgrounds")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• State of background music toggle is now remembered between sessions")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Game Over screen recognizes when a new personal best score is achieved")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Fixed bug that could cause sound effects to occasionally not play")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Fixed bug that could cause the game to crash if a new game is started mid-animation")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
            Text("• Lots of refactoring done in preparation for more new features")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
        }
        
        VStack {
            Text("1.0.1")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("• Fixed bug that caused the Leaderboard to not show all scores")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("ModernAntiqua-Regular", size: 15))
        }
    }
}

#Preview {
    WhatsNewView()
}

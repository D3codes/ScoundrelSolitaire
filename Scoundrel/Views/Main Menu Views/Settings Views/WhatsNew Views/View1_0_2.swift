//
//  View1_0_2.swift
//  Scoundrel
//
//  Created by David Freeman on 3/24/25.
//

import SwiftUI

struct View1_0_2: View {
    var body: some View {
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
    }
}

#Preview {
    View1_0_2()
}

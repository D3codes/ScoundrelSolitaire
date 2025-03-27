//
//  View1_1_1.swift
//  Scoundrel
//
//  Created by David Freeman on 3/27/25.
//

import SwiftUI

struct View1_1_1: View {
    var body: some View {
        VStack {
            Text("1.1.1")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("• New music added!")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Settings menu now has option to skip songs")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• More sound effects")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Stats can now be shared")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• High Score stat no longer requires a Game Center account")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Leaderboard updated to reflect Top 100 scores")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Fixed bug that could cause the resume button to show when there is no game to resume")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    View1_1_1()
}

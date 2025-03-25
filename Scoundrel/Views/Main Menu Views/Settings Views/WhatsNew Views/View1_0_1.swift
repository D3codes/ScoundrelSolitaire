//
//  View1_0_1.swift
//  Scoundrel
//
//  Created by David Freeman on 3/24/25.
//

import SwiftUI

struct View1_0_1: View {
    var body: some View {
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
    View1_0_1()
}

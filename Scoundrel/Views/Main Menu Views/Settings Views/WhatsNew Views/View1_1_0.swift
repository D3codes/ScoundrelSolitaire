//
//  View1_1_0.swift
//  Scoundrel
//
//  Created by David Freeman on 3/24/25.
//

import SwiftUI

struct View1_1_0: View {
    var body: some View {
        VStack {
            Text("1.1.0")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Native iPad App!")
                .font(.custom("ModernAntiqua-Regular", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Supports portrait, landscape, and windowed playing")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• iPad app is also available on macOS and visionOS")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text("Stats")
                .font(.custom("ModernAntiqua-Regular", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Cross-device syncing")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Games played, dungeons beat, and rooms fled")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Average and High Scores")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Leaderboard ranking and achievements")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text("Settings")
                .font(.custom("ModernAntiqua-Regular", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• \"What's New?\" view in settings highlights latest changes")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Credits moved to settings")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Privacy Policy and Support links")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    View1_1_0()
}

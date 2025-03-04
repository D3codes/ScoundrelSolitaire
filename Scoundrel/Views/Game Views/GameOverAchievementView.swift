//
//  GameOverAchievementView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/4/25.
//

import SwiftUI

struct GameOverAchievementView: View {
    var achievementName: String
    var achievementDescription: String
    var achievementImage: String
    
    var body: some View {
        ZStack {
            Group{
                Image("paper")
                    .resizable()
                    .cornerRadius(20)
                
                HStack {
                    Image(achievementImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .mask(Circle())
                    
                    VStack {
                        Text(achievementName)
                            .font(.custom("ModernAntiqua-Regular", size: 20))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        
                        Text(achievementDescription)
                            .font(.custom("ModernAntiqua-Regular", size: 15))
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(width: 300, height: 100)
        }
    }
}

#Preview {
    GameOverAchievementView(
        achievementName: "Were You Even Trying?",
        achievementDescription: "Get the lowest possible score",
        achievementImage: "WereYouEvenTrying"
    )
}

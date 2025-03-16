//
//  AchievementBannerView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/4/25.
//

import SwiftUI
import Vortex

struct AchievementBannerView: View {
    var achievement: GameKitHelper.BinaryAchievement
    
    @State var achievementName: String = ""
    @State var achievementDescription: String = ""
    @State var achievementImage: String = ""

    func setAchievement() {
        switch achievement {
        case .WereYouEvenTrying:
            achievementName = "Were You Even Trying?"
            achievementDescription = "Get the lowest possible score"
            achievementImage = "WereYouEvenTrying"
            break
        case .DefinitelyMeantToDoThat:
            achievementName = "Meant To Do That!"
            achievementDescription = "Die from the weakest monster"
            achievementImage = "DefinitelyMeantToDoThat"
            break
        case .Survivor:
            achievementName = "Survivor"
            achievementDescription = "Make it through a dungeon without dying"
            achievementImage = "Survivor"
            break
        case .SeasonedAdventurer:
            achievementName = "Seasoned Adventurer"
            achievementDescription = "Beat a dungeon with at least 10 life remaining"
            achievementImage = "SeasonedAdventurer"
            break
        case .DungeonMaster:
            achievementName = "Dungeon Master"
            achievementDescription = "Beat a dungeon with at least 20 life remaining"
            achievementImage = "DungeonMaster"
            break
        case .Untouchable:
            achievementName = "Untouchable"
            achievementDescription = "Save the maximum strength health potion for last"
            achievementImage = "Untouchable"
            break
        case .CowardsNeedNotApply:
            achievementName = "Cowards Need Not Apply"
            achievementDescription = "Beat the dungeon without fleeing any rooms"
            achievementImage = "CowardsNeedNotApply"
        case .HangingByAThread:
            achievementName = "Hanging by a Thread"
            achievementDescription = "Complete a dungeon with exactly 1 life remaining"
            achievementImage = "HangingByAThread"
            break
        default:
            achievementName = ""
            achievementDescription = ""
            achievementImage = ""
        }
    }
    
    var body: some View {
        ZStack {
            Group{
                Image("paper")
                    .resizable()
                    .cornerRadius(20)
                
                if !achievementImage.isEmpty {
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
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            
                            Text(achievementDescription)
                                .font(.custom("ModernAntiqua-Regular", size: 15))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .frame(width: 300, height: 100)
        }
        .onAppear { setAchievement() }
    }
}

#Preview {
    struct AchievementBannerView_Preview: View {

        var body: some View {
            AchievementBannerView(
                achievement: .HangingByAThread
            )
        }
    }
    
    return AchievementBannerView_Preview()
}

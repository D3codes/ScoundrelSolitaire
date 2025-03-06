//
//  PauseModalView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/26/25.
//

import SwiftUI

struct PauseModalView: View {
    var continueGame: () -> Void
    var newGame: () -> Void
    var mainMenu: () -> Void
    
    @ObservedObject var room: Room
    
    var body: some View {
        ZStack {
            Group{
                Image("paper")
                    .resizable()
                    .cornerRadius(20)
                
                VStack {
                    Spacer()
                    
                    Text("Pause")
                        .font(.custom("MorrisRoman-Black", size: 50))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                    
                    Spacer()
                    
                    PlankButtonView(text: "Continue", action: continueGame)
                    PlankButtonView(text: "New Game", action: { if !room.isDealingCards { newGame() } })
                    PlankButtonView(text: "Main Menu", action: { if !room.isDealingCards { mainMenu() } })
                    
                    Spacer()
                }
            }
            .frame(width: 300, height: 400)
        }
    }
}

#Preview {
    struct PauseModalView_Preview: View {
        @StateObject var room: Room = Room(cards: [nil, nil, nil, nil], fleedLastRoom: false)
        
        var body: some View {
            PauseModalView(
                continueGame: {},
                newGame: {},
                mainMenu: {},
                room: room
            )
        }
    }
    
    return PauseModalView_Preview()
}

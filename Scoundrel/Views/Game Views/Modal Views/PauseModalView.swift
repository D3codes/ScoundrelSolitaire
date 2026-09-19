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
    var controllerSelection: Int? = nil
    
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
                    
                    PlankButtonView(text: "Main Menu", isControllerFocused: controllerSelection == 0, action: { mainMenu() })
                    PlankButtonView(text: "New Game", isControllerFocused: controllerSelection == 1, action: { newGame() })
                    PlankButtonView(text: "Continue", isControllerFocused: controllerSelection == 2, action: continueGame)
                        .padding(.top)
                    
                    Spacer()
                }
            }
            .frame(minWidth: 300, maxWidth: 300, maxHeight: 400)
        }
    }
}

#Preview {
    struct PauseModalView_Preview: View {
        
        var body: some View {
            PauseModalView(
                continueGame: {},
                newGame: {},
                mainMenu: {}
            )
        }
    }
    
    return PauseModalView_Preview()
}

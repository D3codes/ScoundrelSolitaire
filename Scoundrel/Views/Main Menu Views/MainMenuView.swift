//
//  MainMenuView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var musicPlayer: MusicPlayer
    
    var startGame: () -> Void
    
    @State var showHowToModal: Bool = false
    @State var showCreditsModal: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                TitleBarView()
                
                Spacer()
                Spacer()
                
                PlankButtonView(text: "New Game", action: startGame)
                    .padding(.bottom, 40)
                
                PlankButtonView(text: "How to Play", action: { showHowToModal = true })
                
                PlankButtonView(text: "Credits", action: { showCreditsModal = true })
                
                Spacer()
                
                ControlBarView(musicPlayer: musicPlayer)
            }
            
            if showHowToModal { HowToView(isPresented: $showHowToModal) }
            if showCreditsModal { CreditsView(isPresented: $showCreditsModal) }
        }
    }
}

#Preview {
    struct MainMenuView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        
        var body: some View {
            MainMenuView(
                musicPlayer: musicPlayer,
                startGame: {}
            )
        }
    }
    
    return MainMenuView_Preview()
}

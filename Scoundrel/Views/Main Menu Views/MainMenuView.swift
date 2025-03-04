//
//  MainMenuView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var gameKitHelper: GameKitHelper
    
    var startGame: () -> Void
    
    @State var showHowToModal: Bool = false
    @State var showCreditsModal: Bool = false
    
    @State var page2Sound: AVAudioPlayer?
    
    func initializeSounds() {
        do {
            page2Sound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page2.mp3", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                TitleBarView()
                
                Spacer()
                Spacer()
                
                PlankButtonView(text: "New Game", action: startGame)
                    .padding(.bottom, 40)
                
                PlankButtonView(text: "How to Play", action: {
                    showHowToModal = true
                    page2Sound?.play()
                })
                
                PlankButtonView(text: "Credits", action: {
                    showCreditsModal = true
                    page2Sound?.play()
                })
                
                Spacer()
                
                ControlBarView(
                    musicPlayer: musicPlayer,
                    gameKitHelper: gameKitHelper
                )
            }
        }
        .popover(isPresented: $showHowToModal) {
            HowToView()
                .onAppear { gameKitHelper.hideAccessPoint() }
                .onDisappear { gameKitHelper.showAccessPoint() }
        }
        .popover(isPresented: $showCreditsModal) {
            CreditsView()
                .onAppear { gameKitHelper.hideAccessPoint() }
                .onDisappear { gameKitHelper.showAccessPoint() }
        }
        .onAppear { initializeSounds() }
    }
}

#Preview {
    struct MainMenuView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        @StateObject var gameKitHelper = GameKitHelper()
        
        var body: some View {
            MainMenuView(
                musicPlayer: musicPlayer,
                gameKitHelper: gameKitHelper,
                startGame: {}
            )
        }
    }
    
    return MainMenuView_Preview()
}

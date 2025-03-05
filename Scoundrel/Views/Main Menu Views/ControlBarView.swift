//
//  ControlBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI
import GameKit

struct ControlBarView: View {    
    @ObservedObject var musicPlayer: MusicPlayer
    @ObservedObject var gameKitHelper: GameKitHelper
    
    @State var page2Sound: AVAudioPlayer?
    
    func initializeSounds() {
        do {
            page2Sound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "page2.mp3", ofType:nil)!))
        } catch {
            // couldn't load file :(
        }
    }
    
    @State var isPresentingLeaderboards: Bool = false
    @State var showSignInPopup: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: { self.musicPlayer.isPlaying.toggle() },label: {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 50, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        
                        if musicPlayer.isPlaying {
                            Image(systemName: "music.note")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                        } else {
                            Image("music.note.slash")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .shadow(color: .black, radius: 2, x: 0, y:0 )
                        }
                    }
                })
                .padding(.trailing, 50)
                
                Button(action: {
                    //gameKitHelper.displayDashboard()
                    page2Sound?.play()
                    isPresentingLeaderboards = true
                },label: {
                    ZStack {
                        Image("stoneButton")
                            .resizable()
                            .frame(width: 50, height: 50)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)

                        Image(systemName: "trophy.fill")
                            .foregroundStyle(gameKitHelper.localPlayerIsAuthenticated ? .white : .black)
                            .font(.title2)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                })
                .disabled(!gameKitHelper.localPlayerIsAuthenticated)
                .blur(radius: gameKitHelper.localPlayerIsAuthenticated ? 0 : 0.5)
                .onTapGesture { if !gameKitHelper.localPlayerIsAuthenticated { showSignInPopup = true } }
                .popover(isPresented: $showSignInPopup) {
                    Text("Sign in to Game Center to view Leaderboard")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
                
//                Button(action: { },label: {
//                    ZStack {
//                        Image("stoneButton")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                        .shadow(color: .black, radius: 2, x: 0, y: 0)
//                        
//                        Image(systemName: "gearshape.fill")
//                            .foregroundStyle(.white)
//                            .font(.title2)
//                            .shadow(color: .black, radius: 2, x: 0, y: 0)
//                    }
//                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(
            Image("woodButton")
                .resizable()
                .frame(width: 800)
                .ignoresSafeArea()
                .shadow(color: .black, radius: 5, x: 0, y: -5)
        )
        .popover(isPresented: $isPresentingLeaderboards) { LeaderboardView(gameKitHelper: gameKitHelper) }
        .onAppear() { initializeSounds() }
    }
}

#Preview {
    struct ControlBarView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        @StateObject var gameKitHelper = GameKitHelper()
        
        var body: some View {
            ControlBarView(
                musicPlayer: musicPlayer,
                gameKitHelper: gameKitHelper
            )
        }
    }
    
    return ControlBarView_Preview()
}

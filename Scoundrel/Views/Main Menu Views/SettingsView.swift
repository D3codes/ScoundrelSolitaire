//
//  SettingsView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/13/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    
    @ObservedObject var musicPlayer: MusicPlayer
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Settings")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding(.top)
                
                List {
                    Button(action: { withAnimation { self.musicPlayer.isPlaying.toggle() } },label: {
                        HStack {
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
                            
                            Text("Background Music: \(self.musicPlayer.isPlaying ? "On" : "Off")")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                                .foregroundStyle(.foreground)
                        }
                    })
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                    
                    Button(action: { withAnimation { self.soundEffectsMuted.toggle() } },label: {
                        HStack {
                            ZStack {
                                Image("stoneButton")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                                
                                if !soundEffectsMuted {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                                } else {
                                    Image(systemName: "speaker.slash.fill")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                        .shadow(color: .black, radius: 2, x: 0, y:0 )
                                }
                            }
                            
                            Text("Sound Effects: \(!self.soundEffectsMuted ? "On" : "Off")")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                                .foregroundStyle(.foreground)
                        }
                    })
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                    
                    Button(action: { withAnimation { self.musicPlayer.isPlaying.toggle() } },label: {
                        HStack {
                            ZStack {
                                Image("stoneButton")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                                
                                if musicPlayer.isPlaying {
                                    Image(systemName: "hand.tap.fill")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                                } else {
                                    Image("hand.tap.slash.fill")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                        .shadow(color: .black, radius: 2, x: 0, y:0 )
                                }
                            }
                            
                            Text("Haptic Feedback: \(self.musicPlayer.isPlaying ? "On" : "Off")")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                                .foregroundStyle(.foreground)
                        }
                    })
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                }
                .scrollContentBackground(.hidden)
                
                
                Spacer()
                
                Text("v\(appVersion!)")
                    .font(.custom("ModernAntiqua-Regular", size: 20))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    struct SettingsView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        
        var body: some View {
            SettingsView(
                musicPlayer: musicPlayer
            )
        }
    }
    
    return SettingsView_Preview()
}

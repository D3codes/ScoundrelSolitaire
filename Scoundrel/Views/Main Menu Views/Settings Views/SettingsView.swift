//
//  SettingsView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/13/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @Environment(\.openURL) var openURL
    
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    @AppStorage(UserDefaultsKeys().hapticsEnabled) private var hapticsEnabled: Bool = true
    @AppStorage(UserDefaultsKeys().latestVersionNotesRead) private var latestVersionNotesRead: String = "1.0"
    
    @ObservedObject var musicPlayer: MusicPlayer
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State var showWhatsNew: Bool = false
    @State var showCredits: Bool = false
    @State var showMail = false
    
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
                    Section {
                        Button(action: { self.musicPlayer.isPlaying.toggle() },label: {
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
                                
                                Text("Music: \(self.musicPlayer.isPlaying ? "On" : "Off")")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                                    .foregroundStyle(.foreground)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Capsule())
                        })
                        .buttonStyle(.plain)
                        
                        Button(action: { self.musicPlayer.nextTrack() }, label: {
                            HStack {
                                ZStack {
                                    Image("stoneButton")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                                    Image(systemName: "forward.end.fill")
                                        .foregroundStyle(self.musicPlayer.isPlaying ? .white : .black)
                                        .font(.title2)
                                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                                }
                                
                                if self.musicPlayer.isPlaying {
                                    Text(self.musicPlayer.songs[self.musicPlayer.currentTrackIndex])
                                        .font(.custom("ModernAntiqua-Regular", size: 18))
                                } else {
                                    Text(self.musicPlayer.songs[self.musicPlayer.currentTrackIndex])
                                        .font(.custom("ModernAntiqua-Regular", size: 18))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Capsule())
                        })
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Capsule())
                        .disabled(!self.musicPlayer.isPlaying)
                        .blur(radius: self.musicPlayer.isPlaying ? 0 : 0.5)
                    }
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                     
                    Section {
                        Button(action: { self.soundEffectsMuted.toggle() },label: {
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Capsule())
                        })
                        .buttonStyle(.plain)
                        
                        if UIDevice.current.model == "iPhone" {
                            Button(action: { self.hapticsEnabled.toggle() },label: {
                                HStack {
                                    ZStack {
                                        Image("stoneButton")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                                        
                                        if hapticsEnabled {
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
                                    
                                    Text("Haptic Feedback: \(self.hapticsEnabled ? "On" : "Off")")
                                        .font(.custom("ModernAntiqua-Regular", size: 20))
                                        .foregroundStyle(.foreground)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Capsule())
                            })
                            .buttonStyle(.plain)
                        }
                    }
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                    
                    Section {
                        Button(action: {
                            withAnimation {
                                showWhatsNew.toggle()
                                latestVersionNotesRead = appVersion!
                            }
                        }, label: {
                            HStack {
                                Text("What's New?")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                                
                                Spacer()
                                
                                if latestVersionNotesRead != appVersion! {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.teal)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .rotationEffect(.degrees(showWhatsNew ? 90 : 0))
                            }
                            .foregroundStyle(.foreground)
                        })
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
                        if showWhatsNew {
                            WhatsNewView()
                                .listRowBackground(Rectangle().fill(.regularMaterial))
                        }
                        
                        Button(action: { withAnimation { showCredits.toggle() } }, label: {
                            HStack {
                                Text("Credits")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .rotationEffect(.degrees(showCredits ? 90 : 0))
                            }
                            .foregroundStyle(.foreground)
                        })
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
                        if showCredits {
                            CreditsView()
                                .listRowBackground(Rectangle().fill(.regularMaterial))
                        }
                    }
                    
                    Section {
                        Button(action: { showMail = true }, label: {
                            HStack {
                                Text("Send Feedback")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                                
                                Spacer()
                                
                                Image(systemName: "envelope")
                            }
                            .contentShape(Capsule())
                        })
                        .buttonStyle(.plain)
                        .sheet(isPresented: $showMail) { MailView() }
                        
                        Button(action: { requestReview() }, label: {
                            HStack {
                                Text("Rate Scoundrel Solitaire")
                                    .font(.custom("ModernAntiqua-Regular", size: 20))
                                
                                Spacer()
                                
                                Image(systemName: "star")
                            }
                            .contentShape(Capsule())
                        })
                        .buttonStyle(.plain)
                    }
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                    
                    Section {
                        HStack {
                            Text("Privacy Policy")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            
                            Spacer()
                            
                            Image(systemName: "link")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openURL(URL(string: "https://d3.codes/apps/scoundrelsolitaire/privacypolicy/")!)
                        }
                        
                        HStack {
                            Text("Support")
                                .font(.custom("ModernAntiqua-Regular", size: 20))
                            
                            Spacer()
                            
                            Image(systemName: "link")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openURL(URL(string: "https://d3.codes/apps/scoundrelsolitaire/support/")!)
                        }
                    }
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
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

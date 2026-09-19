//
//  SettingsView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/13/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    private enum ControllerSelection: Hashable {
        case music
        case nextTrack
        case soundEffects
        case haptics
        case credits
        case feedback
        case rate
        case privacy
        case support
    }

    @Environment(\.requestReview) var requestReview
    @Environment(\.openURL) var openURL
    
    @AppStorage(UserDefaultsKeys().soundEffectsMuted) private var soundEffectsMuted: Bool = false
    @AppStorage(UserDefaultsKeys().hapticsEnabled) private var hapticsEnabled: Bool = true
    @AppStorage(UserDefaultsKeys().latestVersionNotesRead) private var latestVersionNotesRead: String = "1.0"
    
    @ObservedObject var musicPlayer: MusicPlayer
    @EnvironmentObject private var controllerInput: ControllerInputMonitor
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State var showWhatsNew: Bool = false
    @State var showCredits: Bool = false
    @State var showMail = false
    @State private var controllerSelection: ControllerSelection = .music

    private var availableControllerSelections: [ControllerSelection] {
        var selections: [ControllerSelection] = [.music]
        if musicPlayer.isPlaying { selections.append(.nextTrack) }
        selections.append(.soundEffects)
        if UIDevice.current.model == "iPhone" { selections.append(.haptics) }
        selections.append(contentsOf: [.credits, .feedback, .rate, .privacy, .support])
        return selections
    }

    private func isControllerFocused(_ selection: ControllerSelection) -> Bool {
        controllerInput.isControllerConnected && controllerSelection == selection
    }

    private func handleControllerInput(_ input: ControllerInput, proxy: ScrollViewProxy) {
        let selections = availableControllerSelections
        guard !selections.isEmpty else { return }
        if !selections.contains(controllerSelection) { controllerSelection = selections[0] }

        switch input {
        case .up, .left, .down, .right:
            let currentIndex = selections.firstIndex(of: controllerSelection) ?? 0
            let offset = input == .up || input == .left ? -1 : 1
            controllerSelection = selections[(currentIndex + offset + selections.count) % selections.count]
            withAnimation { proxy.scrollTo(controllerSelection, anchor: .center) }
        case .primary:
            activateControllerSelection()
        case .secondary, .menu:
            break
        }
    }

    private func activateControllerSelection() {
        switch controllerSelection {
        case .music: musicPlayer.isPlaying.toggle()
        case .nextTrack: if musicPlayer.isPlaying { musicPlayer.nextTrack() }
        case .soundEffects: soundEffectsMuted.toggle()
        case .haptics: hapticsEnabled.toggle()
        case .credits: withAnimation { showCredits.toggle() }
        case .feedback: showMail = true
        case .rate: requestReview()
        case .privacy: openURL(URL(string: "https://d3.codes/apps/scoundrelsolitaire/privacypolicy/")!)
        case .support: openURL(URL(string: "https://d3.codes/apps/scoundrelsolitaire/support/")!)
        }
    }
    
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
                
                ScrollViewReader { proxy in
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
                        .controllerFocused(isControllerFocused(.music))
                        .id(ControllerSelection.music)
                        
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
                        .controllerFocused(isControllerFocused(.nextTrack))
                        .id(ControllerSelection.nextTrack)
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
                        .controllerFocused(isControllerFocused(.soundEffects))
                        .id(ControllerSelection.soundEffects)
                        
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
                            .controllerFocused(isControllerFocused(.haptics))
                            .id(ControllerSelection.haptics)
                        }
                    }
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                    
                    Section {
//                        Button(action: {
//                            withAnimation {
//                                showWhatsNew.toggle()
//                                latestVersionNotesRead = appVersion!
//                            }
//                        }, label: {
//                            HStack {
//                                Text("What's New?")
//                                    .font(.custom("ModernAntiqua-Regular", size: 20))
//
//                                Spacer()
//
//                                if latestVersionNotesRead != appVersion! {
//                                    Image(systemName: "exclamationmark.triangle.fill")
//                                        .foregroundStyle(.teal)
//                                }
//
//                                Image(systemName: "chevron.right")
//                                    .rotationEffect(.degrees(showWhatsNew ? 90 : 0))
//                            }
//                            .foregroundStyle(.foreground)
//                        })
//                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        
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
                        .controllerFocused(isControllerFocused(.credits))
                        .id(ControllerSelection.credits)
                        
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
                        .controllerFocused(isControllerFocused(.feedback))
                        .id(ControllerSelection.feedback)
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
                        .controllerFocused(isControllerFocused(.rate))
                        .id(ControllerSelection.rate)
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
                        .controllerFocused(isControllerFocused(.privacy))
                        .id(ControllerSelection.privacy)
                        
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
                        .controllerFocused(isControllerFocused(.support))
                        .id(ControllerSelection.support)
                    }
                    .listRowBackground(Rectangle().fill(.thinMaterial))
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .onChange(of: controllerInput.occurrence) { _, occurrence in
                    guard let occurrence else { return }
                    handleControllerInput(occurrence.input, proxy: proxy)
                }
                }
            }
        }
    }
}

#Preview {
    struct SettingsView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        
        var body: some View {
            Text("HI")
                .sheet(isPresented: .constant(true)) {
                    SettingsView(
                        musicPlayer: musicPlayer
                    )
                }
        }
    }
    
    return SettingsView_Preview()
}

//
//  ControlBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct ControlBarView: View {
    @ObservedObject var musicPlayer: MusicPlayer
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: { musicPlayer.isPlaying.toggle() },label: {
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
    }
}

#Preview {
    struct ControlBarView_Preview: View {
        @StateObject var musicPlayer = MusicPlayer()
        
        var body: some View {
            ControlBarView(musicPlayer: musicPlayer)
        }
    }
    
    return ControlBarView_Preview()
}

//
//  AchievementHighlightView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/5/25.
//

import SwiftUI

struct AchievementHighlightView: View {
    var title: String
    var description: String
    var image: String
    var animationNamespace: Namespace.ID
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundStyle(.ultraThinMaterial)
                .opacity(0.7)
                .onTapGesture { withAnimation { isPresented = false } }
            
            Group {
                Image("paper")
                    .resizable()
                    .cornerRadius(20)
                
                VStack {
                    Text(title)
                        .font(.custom("ModernAntiqua-Regular", size: 40))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Image(image)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .padding(.vertical)
                    
                    Text(description)
                        .font(.custom("ModernAntiqua-Regular", size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .frame(width: 300, height: 600)
        }
    }
}

#Preview {
    struct AchievementHighlightView_Preview: View {
        @Namespace var namespace
        @State var isPresented: Bool = true
        
        var body: some View {
            AchievementHighlightView(
                title: "Were You Even Trying?",
                description: "Get the lowest possible score",
                image: "WereYouEvenTrying",
                animationNamespace: namespace,
                isPresented: $isPresented
            )
        }
    }
    
    return AchievementHighlightView_Preview()
}

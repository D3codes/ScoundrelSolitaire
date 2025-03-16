//
//  PlankButtonView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct PlankButtonView: View {
    var text: String
    var action: () -> Void
    
    var plankTextures: [String] = [
        "plank1",
        "plank2"
    ]
    
    var body: some View {
        Button(action: { action() }, label: {
            ZStack {
                Image(plankTextures.randomElement()!)
                    .resizable()
                    .frame(width: 200, height: 50)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                Text(text)
                    .font(.custom("ModernAntiqua-Regular", size: 30))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
            }
        })
    }
}

#Preview {
    struct PlankButtonView_Preview: View {
        
        var body: some View {
            PlankButtonView(text: "How to Play", action: {})
        }
    }
    
    return PlankButtonView_Preview()
}

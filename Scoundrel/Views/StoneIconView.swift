//
//  StoneIconView.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

import SwiftUI

struct StoneIconView: View {
    var enabledImage: Image
    var disabledImage: Image?
    var isEnabled: Bool?
    
    var body: some View {
        ZStack {
            Image("stoneButton")
                .resizable()
                .frame(width: 40, height: 40)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            if isEnabled ?? true {
                enabledImage
                    .foregroundStyle(.white)
                    .font(.title2)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
            } else if let disabledImage {
                disabledImage
                    .foregroundStyle(.white)
                    .font(.title2)
                    .shadow(color: .black, radius: 2, x: 0, y:0 )
            }
            
            
        }
    }
}

#Preview {
    StoneIconView(
        enabledImage: Image(systemName: "music.note")
    )
}

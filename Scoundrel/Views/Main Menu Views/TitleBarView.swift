//
//  TitleBarView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct TitleBarView: View {
    var body: some View {
        ZStack {
            Text("SCOUNDREL")
                .font(.custom("MorrisRoman-Black", size: 40))
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(
            Image("stoneSlab2")
                .resizable()
                .frame(width: 800)
                .ignoresSafeArea()
                .shadow(color: .black, radius: 15, x: 0, y: 5)
        )
    }
}

#Preview {
    TitleBarView()
}

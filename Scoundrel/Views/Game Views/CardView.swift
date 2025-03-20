//
//  CardView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var card: Card
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black, radius: 5, x: 5, y: 5)
                
            VStack(spacing: 0) {
                Image("\(card.getImageName())")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                
                HStack {
                    Image("\(card.getIcon())")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 35, maxHeight: 35)
                    
                    Text("\(card.strength)")
                        .font(.custom("ModernAntiqua-Regular", size: 35))
                        .foregroundStyle(.black)
                }
                .padding(.bottom)
            }
        }
        .aspectRatio(0.75, contentMode: .fit)
    }
}

#Preview {
    CardView(card: .init(suit: .healthPotion, strength: 2))
}

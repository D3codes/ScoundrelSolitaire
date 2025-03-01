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
                
            
            VStack {
                Image("\(card.getImageName())")
                    .resizable()
                    .frame(width: 125, height: 125)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                HStack {
                    Image("\(card.getIcon())")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("\(card.strength)")
                        .font(.custom("ModernAntiqua-Regular", size: 30))
                        .foregroundStyle(.black)
                }
            }
        }
        .frame(width: 150, height: 200)
    }
}

#Preview {
    CardView(card: .init(suit: .healthPotion, strength: 2))
}

//
//  View1_1_3.swift
//  Scoundrel
//
//  Created by David Freeman on 11/9/25.
//

import SwiftUI

struct View1_1_3: View {
    var body: some View {
        VStack {
            Text("1.1.3")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("• Added damage calculation to attack buttons")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Added sound effect when taking potion fails")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Fixed bug that caused some buttons to have a small tap target")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Fixed bug that could cause the Game Center overlay to persist during gameplay")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Now enforcing minimum window sizes on windowed OSes")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• Added feedback and rating buttons to Settings")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    View1_1_3()
}

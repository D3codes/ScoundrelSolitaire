//
//  View1_1_1.swift
//  Scoundrel
//
//  Created by David Freeman on 3/27/25.
//

import SwiftUI

struct View1_1_2: View {
    var body: some View {
        VStack {
            Text("1.1.2")
                .font(.custom("ModernAntiqua-Regular", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("• Adopted liquid glass design language")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("• New app icon styles")
                .font(.custom("ModernAntiqua-Regular", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    View1_1_2()
}

//
//  StatsView.swift
//  Scoundrel
//
//  Created by David Freeman on 3/23/25.
//

import SwiftUI

struct StatsView: View {
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            Text("StatsView")
        }
    }
}

#Preview {
    struct StatsView_Preview: View {
        
        var body: some View {
            StatsView()
        }
    }
    
    return StatsView_Preview()
}

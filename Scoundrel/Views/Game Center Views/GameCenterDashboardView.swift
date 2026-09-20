//
//  GameCenterDashboardView.swift
//  Scoundrel
//
//  Created by David Freeman on 11/8/25.
//

import GameKit
import SwiftUI

struct GameCenterDashboardView: View {
    var body: some View {
        Color.clear
            .onAppear {
                GKAccessPoint.shared.trigger(state: .dashboard) {}
            }
    }
}

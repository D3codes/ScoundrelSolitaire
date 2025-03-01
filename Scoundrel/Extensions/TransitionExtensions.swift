//
//  TransitionExtensions.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

extension AnyTransition {
    static var opacityAndScale: AnyTransition {
        AnyTransition.opacity.combined(with: .scale)
    }
}

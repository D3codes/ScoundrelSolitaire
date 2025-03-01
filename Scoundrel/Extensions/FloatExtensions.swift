//
//  FloatExtensions.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import QuartzCore

extension Float {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Float {
        return Float(CGFloat(self).map(from: from, to: to))
    }
}

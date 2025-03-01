//
//  DoubleExtensions.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import QuartzCore

extension Double {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Double {
        return Double(CGFloat(self).map(from: from, to: to))
    }
}

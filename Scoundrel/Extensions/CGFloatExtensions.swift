//
//  CGFloatExtensions.swift
//  Scoundrel
//
//  Created by David Freeman on 2/25/25.
//

import QuartzCore

extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}

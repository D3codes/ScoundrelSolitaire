//
//  GeometryProxyExtensions.swift
//  Scoundrel
//
//  Created by David Freeman on 9/30/26.
//

import SwiftUI

@available(iOS 27.1, *)
extension GeometryProxy {
    var dividingReservedRegion: ReservedRegion? {
        let bounds = CGRect(origin: .zero, size: size)

        return reservedRegions(kind: .division).first { region in
            if region.frame.height > region.frame.width {
                return region.frame.minX > bounds.minX && region.frame.maxX < bounds.maxX
            } else {
                return region.frame.minY > bounds.minY && region.frame.maxY < bounds.maxY
            }
        }
    }
}

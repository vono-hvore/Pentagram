//
//  CGRect+Extension.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 21.06.2025.
//

import CoreGraphics

public extension CGRect {
    init(centroid: CGPoint, width: CGFloat, height: CGFloat) {
        self.init(
            x: centroid.x - width / 2,
            y: centroid.y - height / 2,
            width: width,
            height: height
        )
    }
}

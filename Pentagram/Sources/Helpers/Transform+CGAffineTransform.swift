//
//  Transform+CGAffineTransform.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

public extension CGAffineTransform {
    func translated(by delta: CGPoint) -> Self {
        translatedBy(x: delta.x, y: delta.y)
    }

    func scaled(by amount: CGFloat) -> Self {
        scaledBy(x: amount, y: amount)
    }
}

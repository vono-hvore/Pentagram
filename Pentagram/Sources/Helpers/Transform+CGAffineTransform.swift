//
//  Transform+CGAffineTransform.swift
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

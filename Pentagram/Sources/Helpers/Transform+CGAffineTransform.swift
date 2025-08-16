//
//  Transform+CGAffineTransform.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

extension CGAffineTransform {
    public func translated(by delta: CGPoint) -> Self {
        self.translatedBy(x: delta.x, y: delta.y)
    }
    
    public func scaled(by amount: CGFloat) -> Self {
        self.scaledBy(x: amount, y: amount)
    }
}

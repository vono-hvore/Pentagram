//
//  Transform+CGAffineTransform.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

extension Transform {
    public var affineTransform: CGAffineTransform {
        CGAffineTransform(
            translationX: translation.x,
            y: translation.y
        )
        .rotated(by: rotation)
        .scaledBy(x: scale, y: scale)
    }
    
    
    public func translated(by delta: CGPoint) -> Self {
        .init(
            translation: CGPoint(
                x: translation.x + delta.x,
                y: translation.y + delta.y
            ),
            rotation: rotation,
            scale: scale
        )
    }
    
    public func scaled(by amount: CGFloat) -> Self {
        .init(
            translation: translation,
            rotation: rotation,
            scale: scale * amount
        )
    }
    
    public func rotated(by radians: CGFloat) -> Self {
        .init(
            translation: translation,
            rotation: rotation + radians,
            scale: scale
        )
    }
}

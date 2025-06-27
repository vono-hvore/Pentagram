//
//  CGPoint+Extension.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import Foundation

public extension CGPoint {
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static prefix func - (_ lhs: CGPoint) -> CGPoint {
        return CGPoint(x: -lhs.x, y: -lhs.y)
    }
    
    static func distance(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
        (pow(lhs.x - rhs.x, 2) + pow(lhs.y - rhs.y, 2)).squareRoot()
    }
    
    static func middlePoint(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: (lhs.x + rhs.x) / 2, y: (lhs.y + rhs.y) / 2)
    }
}

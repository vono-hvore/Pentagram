//
//  CGPoint+Extension.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import Foundation

extension CGPoint {
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

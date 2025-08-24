//
//  CGPoint+Extension.swift
//

import Foundation

public extension CGPoint {
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static prefix func - (_ lhs: CGPoint) -> CGPoint {
        CGPoint(x: -lhs.x, y: -lhs.y)
    }

    static func distance(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
        (pow(lhs.x - rhs.x, 2) + pow(lhs.y - rhs.y, 2)).squareRoot()
    }

    static func middlePoint(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: (lhs.x + rhs.x) / 2, y: (lhs.y + rhs.y) / 2)
    }

    // swiftlint:disable identifier_name
    static func distanceFromPointToSegment(_ p: CGPoint, _ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let ab = b - a
        let ap = p - a
        let abLengthSquared = ab.x * ab.x + ab.y * ab.y
        if abLengthSquared == 0 { return CGPoint.distance(a, p) }
        let t = max(0, min(1, (ap.x * ab.x + ap.y * ab.y) / abLengthSquared))
        let projection = CGPoint(x: a.x + ab.x * t, y: a.y + ab.y * t)

        return CGPoint.distance(p, projection)
    }
    // swiftlint:enable identifier_name
}

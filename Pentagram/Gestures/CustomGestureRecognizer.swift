//
//  CustomGestureRecognizer.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import UIKit

struct TouchPoint {
    var location: CGPoint = .zero
    var touchTime: CFTimeInterval = .zero
}

extension TouchPoint {
    func velocity(_ lhs: Self) -> CGPoint {
        let dx = location - lhs.location
        let dt = CGFloat(touchTime - lhs.touchTime)
        return CGPoint(
            x: dx.x / dt,
            y: dx.y / dt
        )
    }
}

class CustomGestureRecognizer: UIGestureRecognizer {
    private let threshold: CGFloat = 10
    private var firstTouchPoint: TouchPoint = .init()
    private var lastTouchPoint: TouchPoint = .init()
    private var touch: UITouch?
}

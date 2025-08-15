//
//  NoDelayPanGestureRecognizer.swift
//

import UIKit

class NoDelayPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        state = .began
    }
}

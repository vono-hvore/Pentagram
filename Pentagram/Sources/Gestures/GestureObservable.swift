//
//  GestureObservable.swift
//

import Foundation

@MainActor
public protocol GestureObservable: Sendable {
    func receiveStartState(at point: CGPoint)

    func receiveMovedState(to point: CGPoint, deltaT: TimeInterval)

    func receiveEndState(at point: CGPoint)

    func receiveCancelledState()

    func receiveRotation(radians: CGFloat)

    func receiveRotationStart(at point: CGPoint)
}

//
//  GestureObservable.swift
//

import Foundation

@MainActor
protocol GestureObservable: Sendable {
    func receiveStartState(at point: CGPoint)

    func receiveMovedState(to point: CGPoint, deltaT: TimeInterval)

    func receiveEndState(at point: CGPoint)

    func receiveCancelledState()

    func receiveRotation(radians: CGFloat)
}

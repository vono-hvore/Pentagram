//
//  GestureObservable.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import Foundation

@MainActor
protocol GestureObservable: Sendable {
    func receiveStartState(at point: CGPoint) async
    func receiveMovedState(to point: CGPoint, dt: TimeInterval) async
    func receiveEndState(at point: CGPoint) async
    func receiveCancelledState() async
    func receiveRotation(radians: CGFloat) async
    func receiveRotationStart(at point: CGPoint) async
}

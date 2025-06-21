//
//  GestureObservable.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import Foundation

protocol GestureObservable: Sendable {
    func receiveStartState(at point: CGPoint) async
    func receiveMovedState(to point: CGPoint, dt: TimeInterval) async
    func receiveEndState(at point: CGPoint) async
    func receiveCancelledState() async
}

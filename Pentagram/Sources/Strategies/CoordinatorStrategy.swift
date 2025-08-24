//
//  CoordinatorStrategy.swift
//

import Foundation

@MainActor
protocol CoordinatorStrategy: Sendable {
    func receiveStartState(context: ShapeContext, at point: CGPoint)

    func receiveMovedState(context: ShapeContext, to point: CGPoint, deltaT: TimeInterval)

    func receiveEndState(context: ShapeContext, at point: CGPoint)

    func receiveCancelledState(context: ShapeContext)

    func receiveRotation(context: ShapeContext, radians: CGFloat)

}

@MainActor
protocol ShapeContext {
    func dequeueContainer(where: @escaping (ShapeContainer) -> Bool) -> ShapeContainer?

    func enqueueContainer(_ container: ShapeContainer)

    func selectedContainer() -> ShapeContainer

    func selectContainer(_ container: ShapeContainer)

    func resetSelectedContainer()
}

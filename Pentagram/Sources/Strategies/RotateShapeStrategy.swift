//
//  RotateShapeStrategy.swift
//

import Foundation

@MainActor
final class RotateShapeStrategy: CoordinatorStrategy {
    func receiveStartState(context: ShapeContext, at point: CGPoint) {
        let currentContainer = context.dequeueContainer { $0.contains(point: point) }
        guard var currentContainer else { return }

        currentContainer.setAnchor(at: point)
        context.selectContainer(currentContainer)
    }

    func receiveRotation(context: ShapeContext, radians: CGFloat) {
        var currentContainer = context.selectedContainer()
        currentContainer.rotate(by: radians)
        context.selectContainer(currentContainer)
    }

    func receiveEndState(context: ShapeContext, at point: CGPoint) {
        guard context.selectedContainer().containsShapes else { return }

        context.enqueueContainer(context.selectedContainer())
        context.resetSelectedContainer()
    }

    func receiveCancelledState(context: ShapeContext) {
        context.resetSelectedContainer()
    }

    func receiveMovedState(context: ShapeContext, to point: CGPoint, deltaT: TimeInterval) {}
}

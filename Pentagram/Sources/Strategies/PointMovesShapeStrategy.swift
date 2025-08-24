//
//  PointMovesShapeStrategy.swift
//

import Foundation

@MainActor
final class PointMovesShapeStrategy: CoordinatorStrategy {
    func receiveStartState(context: ShapeContext, at point: CGPoint) {
        let currentShape = context.dequeueContainer { $0.contains(point: point) }
        guard var currentShape else { return }

        currentShape.setAnchor(at: point)
        context.selectContainer(currentShape)
    }

    func receiveEndState(context: ShapeContext, at point: CGPoint) {
        guard context.selectedContainer().containsShapes else { return }

        context.enqueueContainer(context.selectedContainer())
        context.resetSelectedContainer()
    }

    func receiveCancelledState(context: ShapeContext) {
        context.resetSelectedContainer()
    }

    func receiveMovedState(context: ShapeContext, to point: CGPoint, deltaT: TimeInterval) {
        var currentContainer = context.selectedContainer()
        currentContainer.move(to: point)
        context.selectContainer(currentContainer)
    }

    func receiveRotation(context: ShapeContext, radians: CGFloat) {}
}

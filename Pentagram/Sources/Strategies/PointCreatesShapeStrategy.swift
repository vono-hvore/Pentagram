//
//  PointCreatesShapeStrategy.swift
//

import Foundation

public typealias PointCreatesShapeFactory = @Sendable @MainActor (_ points: [CGPoint]) -> ShapeState

@MainActor
final class PointCreatesShapeStrategy: CoordinatorStrategy {
    private let factory: PointCreatesShapeFactory

    init(_ factory: @escaping PointCreatesShapeFactory) {
        self.factory = factory
    }

    func receiveStartState(context: ShapeContext, at point: CGPoint) {
        let newContainer = ShapeContainer()
        context.selectContainer(newContainer)
    }

    func receiveEndState(context: ShapeContext, at point: CGPoint) {
        var currentContainer = context.selectedContainer()
        currentContainer.points.append(point)
        let shapeState = factory(currentContainer.points)
        switch shapeState {
        case .final(let shape):
            context.resetSelectedContainer()
            var newContainer = ShapeContainer()
            newContainer.add(shape: shape)
            context.enqueueContainer(newContainer)
        case .draft(let draft):
            currentContainer.add(shape: draft)
            context.selectContainer(currentContainer)
        }
    }

    func receiveCancelledState(context: ShapeContext) {
        context.resetSelectedContainer()
    }

    func receiveRotationStart(context: ShapeContext, at point: CGPoint) {}
    func receiveRotation(context: ShapeContext, radians: CGFloat) {}
    func receiveMovedState(context: ShapeContext, to point: CGPoint, deltaT _: TimeInterval) {}
}

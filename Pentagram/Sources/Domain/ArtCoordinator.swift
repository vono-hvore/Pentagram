//
//  ArtCoordinator.swift
//

import CoreGraphics
import Foundation

public enum Action {
    case move
    case rotate
    case draw(any ShapeSelector)
    case freeze
}

@MainActor
public final class ArtCoordinator: Render {
    private var actionState: Action = .move
    private var containers: [ShapeContainer] = []
    private var currentContainer: ShapeContainer = .init()
    private var pointsCreatesShapeFactories: [AnyShapeSelector: PointCreatesShapeFactory]

    public init(
        factories: [some ShapeSelector: PointCreatesShapeFactory]
    ) {
        self.pointsCreatesShapeFactories = factories
    }

    public func acceptVisitor(_ visitor: any ShapeVisitor) {
        containers.forEach { $0.acceptVisitor(visitor) }
    }

    public func draw(in context: CGContext) {
        containers.forEach { $0.draw(in: context) }
        currentContainer.draw(in: context)
    }

    public func select(action newState: Action) {
        actionState = newState
    }

    public func eraseAll() {
        containers = []
        currentContainer.eraseAll()
    }

    public func prepareToRotation() {
        switch actionState {
        case .move:
            select(action: .rotate)
        case .draw, .freeze, .rotate:
            break
        }
    }
}

// MARK: - Gesture Observable

extension ArtCoordinator: GestureObservable {
    func receiveStartState(at point: CGPoint) {
        switch actionState {
        case .move:
            PointMovesShapeStrategy().receiveStartState(context: self, at: point)
        case .rotate:
            RotateShapeStrategy().receiveStartState(context: self, at: point)
        case .draw(let shapeType):
            guard let factory = pointsCreatesShapeFactories[shapeType.eraseToAnyShapeSelector] else { return }

            PointCreatesShapeStrategy(factory).receiveStartState(context: self, at: point)
        case .freeze: break
        }
    }

    func receiveMovedState(to point: CGPoint, deltaT: TimeInterval) {
        switch actionState {
        case .move:
            PointMovesShapeStrategy().receiveMovedState(context: self, to: point, deltaT: deltaT)
        case .rotate:
            RotateShapeStrategy().receiveMovedState(context: self, to: point, deltaT: deltaT)
        case .draw(let shapeType):
            guard let factory = pointsCreatesShapeFactories[shapeType.eraseToAnyShapeSelector] else { return }

            PointCreatesShapeStrategy(factory).receiveMovedState(
                context: self, to: point, deltaT: deltaT)
        case .freeze: break
        }
    }

    func receiveRotation(radians: CGFloat) {
        switch actionState {
        case .move:
            PointMovesShapeStrategy().receiveRotation(context: self, radians: radians)
        case .rotate:
            RotateShapeStrategy().receiveRotation(context: self, radians: radians)
        case .draw(let shapeType):
            guard let factory = pointsCreatesShapeFactories[shapeType.eraseToAnyShapeSelector] else { return }

            PointCreatesShapeStrategy(factory).receiveRotation(context: self, radians: radians)
        case .freeze: break
        }
    }

    func receiveEndState(at point: CGPoint) {
        switch actionState {
        case .move:
            PointMovesShapeStrategy().receiveEndState(context: self, at: point)
        case .rotate:
            RotateShapeStrategy().receiveEndState(context: self, at: point)
            select(action: .move)
        case .draw(let shapeType):
            guard let factory = pointsCreatesShapeFactories[shapeType.eraseToAnyShapeSelector] else { return }

            PointCreatesShapeStrategy(factory).receiveEndState(context: self, at: point)
        case .freeze: break
        }
    }

    func receiveCancelledState() {
        switch actionState {
        case .move:
            PointMovesShapeStrategy().receiveCancelledState(context: self)
        case .rotate:
            RotateShapeStrategy().receiveCancelledState(context: self)
        case .draw(let shapeType):
            guard let factory = pointsCreatesShapeFactories[shapeType.eraseToAnyShapeSelector] else { return }

            PointCreatesShapeStrategy(factory).receiveCancelledState(context: self)
        case .freeze: break
        }
    }
}

// MARK: - Shape Context

extension ArtCoordinator: ShapeContext {
    func dequeueContainer(where predicate: @escaping (ShapeContainer) -> Bool) -> ShapeContainer? {
        var container: ShapeContainer?
        containers.removeAll {
            guard predicate($0) else { return false }
            container = $0
            return true
        }
        return container
    }

    func enqueueContainer(_ container: ShapeContainer) {
        containers.append(container)
    }

    func selectedContainer() -> ShapeContainer {
        currentContainer
    }

    func selectContainer(_ container: ShapeContainer) {
        currentContainer = container
    }

    func resetSelectedContainer() {
        currentContainer = .init()
    }
}

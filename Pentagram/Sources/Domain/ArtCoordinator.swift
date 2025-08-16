//
//  ArtCoordinator.swift
//

import Foundation
import UIKit

public typealias ArtCoordinatorProtocol = GestureObservable & Render

public extension ArtCoordinator {
    enum ActionTool {
        case draw(ShapeType)
        case move
        case freeze
    }
}

@MainActor
public final class ArtCoordinator<ShapeType: Hashable>: ArtCoordinatorProtocol {
    private var tool: ActionTool = .move
    private var containers: [ShapeContainer] = []
    private var currentContainer: ShapeContainer = .init()
    private var factories: [ShapeType: any ShapeFactory]
    
    public init(
        factories: [ShapeType: any ShapeFactory]
    ) {
        self.factories = factories
    }
    
    public func draw(in context: CGContext) {
        containers.forEach { $0.draw(in: context) }
        currentContainer.draw(in: context)
    }
    
    public func select(tool newTool: ActionTool) {
        tool = newTool
    }
    
    public func eraseAll() {
        containers = []
        currentContainer.eraseAll()
    }
    
    public func addPoint(at point: CGPoint) {
        if case let .draw(shapeType) = tool, let factory = factories[shapeType] {
            factory.make(with: point) { finalShape in
                currentContainer.eraseAll()
                currentContainer.add(shape: finalShape)
                containers.append(currentContainer)
                currentContainer = .init()
            } rawDraft: { draft in
                currentContainer.add(shape: draft)
            }
        }
    }
}

// MARK: - Gesture Observable

extension ArtCoordinator {
    public func receiveRotationStart(at point: CGPoint) {
        switch tool {
        case .move:
            let currentContainerIndex = containers.lastIndex { $0.contains(point: point) }
            guard let currentContainerIndex else { return }
            
            currentContainer = containers.remove(at: currentContainerIndex)
            currentContainer.setAnchor(at: point)
        case .draw, .freeze: break
        }
    }
    
    public func receiveRotation(radians: CGFloat) {
        switch tool {
        case .move:
            currentContainer.rotate(by: radians)
        case .draw, .freeze: break
        }
    }
    
    public func receiveStartState(at point: CGPoint) {
        switch tool {
        case .move:
            let currentContainerIndex = containers.lastIndex { $0.contains(point: point) }
            guard let currentContainerIndex else { return }
            
            currentContainer = containers.remove(at: currentContainerIndex)
            currentContainer.setAnchor(at: point)
        case .draw, .freeze: break
        }
    }
    
    public func receiveMovedState(to point: CGPoint, dt: TimeInterval) {
        switch tool {
        case .move:
            currentContainer.move(to: point)
        case .draw, .freeze: break
        }
    }
    
    public func receiveEndState(at point: CGPoint) {
        switch tool {
        case .move:
            if currentContainer.containsShapes {
                containers.append(currentContainer)
            }
            currentContainer = .init()
        case .draw:
            addPoint(at: point)
        case .freeze: break
        }
    }
    
    public func receiveCancelledState() {
        switch tool {
        case .move:
            if currentContainer.containsShapes {
                containers.append(currentContainer)
            }
            currentContainer = .init()
        case .draw, .freeze: break
        }
    }
}

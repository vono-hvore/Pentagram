//
//  ArtCoordinator.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import Foundation
import UIKit

public enum Tool {
    case line
    case select
}

@MainActor
class ArtCoordinator {
    let id: UUID = UUID()
    private var tool: Tool = .line
    private var artists: [Picasso] = []
    private var picasso: Picasso = .init()
    private var shapePointsFactories: [Tool: PointFactory]
    
    init(
        shapePointsFactories: [Tool: PointFactory] = [:]
    ) {
        self.shapePointsFactories = shapePointsFactories
    }
    
    func draw(in context: CGContext) {
        artists.forEach { $0.draw(in: context) }
        picasso.draw(in: context)
    }
    
    func select(tool newTool: Tool) {
        tool = newTool
    }
}

extension ArtCoordinator: GestureObservable {
    func receiveRotationStart(at point: CGPoint) async {
        switch tool {
        case .select:
            picasso = artists.removeLast()
            picasso.setAnchor(point)
        case .line: break
        }
    }
    
    func receiveRotation(radians: CGFloat) async {
        switch tool {
        case .select:
            picasso.rotate(by: radians)
        case .line: break
        }
    }
    
    func receiveStartState(at point: CGPoint) async {
        switch tool {
        case .select:
            let picassoIndex = artists.lastIndex { $0.contains(point) }
            guard let picassoIndex else { return }
            
            picasso = artists.remove(at: picassoIndex)
            picasso.setAnchor(point)
        case .line:
            break
        }
    }
    
    func receiveMovedState(to point: CGPoint, dt: TimeInterval) async {
        switch tool {
        case .select:
            picasso.move(to: point)
        case .line: break
        }
    }
    
    func receiveEndState(at point: CGPoint) async {
        switch tool {
        case .select:
            if picasso.containsShapes {
                artists.append(picasso)
            }
            picasso = .init()
        case .line:
            let factory = shapePointsFactories[tool]
            await factory?.setDelegate(self)
            await factory?.addPoint(point)
        }
    }
    
    func receiveCancelledState() async {
        switch tool {
        case .select:
            if picasso.containsShapes {
                artists.append(picasso)
            }
            picasso = .init()
        case .line: break
        }
    }
}

extension ArtCoordinator: ArtHandler {
    func complete(_ shape: some Shape) async {
        picasso.erase()
        picasso.order(shape)
        artists.append(picasso)
        picasso = .init()
        shapePointsFactories[tool] = await shapePointsFactories[tool]?.complete()
    }
    
    func inProgerss(_ draft: some Shape) {
        picasso.order(draft)
    }
}

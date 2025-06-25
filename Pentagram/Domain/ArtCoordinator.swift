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
    private lazy var factory: LineDotsShapeFactory = {
        .init(self, dotRadius: 7)
    }()
    
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
            await factory.addPoint(point)
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
    func complete(_ shape: any Shape) {
        picasso.erase()
        picasso.order(shape)
        artists.append(picasso)
        factory = LineDotsShapeFactory(self, dotRadius: 7)
        picasso = .init()
    }
    
    func inProgerss(_ draft: any Shape) {
        picasso.order(draft)
    }
}

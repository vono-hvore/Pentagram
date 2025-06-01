//
//  ArtCoordinator.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import Foundation
import UIKit

@MainActor
class ArtCoordinator {
    let id: UUID = UUID()
    private var artists: [Picasso] = []
    private var picasso: Picasso = .init()
    private lazy var factory: LineDotsShapeFactory = {
        .init(self, dotRadius: 7)
    }()
    
    func draw(in context: CGContext) {
        picasso.draw(in: context)
        artists.forEach { $0.draw(in: context) }
    }
}

extension ArtCoordinator: GestureObservable {
    func receiveStartState(at point: CGPoint) async {}
    
    func receiveMovedState(to point: CGPoint, dt: TimeInterval) {}
    
    func receiveEndState(at point: CGPoint) async {
        await factory.addPoint(point)
    }
    
    func receiveCancelledState() {}
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

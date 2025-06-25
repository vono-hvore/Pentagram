//
//  LineDotsShapeFactory.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 21.06.2025.
//

import Foundation

protocol ArtFactory {}

protocol ArtHandler: Sendable {
    func inProgerss(_ draft: any Shape) async
    func complete(_ shape: any Shape) async
}

protocol PointHandler: Sendable {
    func addPoint(_ point: CGPoint) async
}

actor LineDotsShapeFactory: ArtFactory, PointHandler {
    private let dotRadius: CGFloat
    private var dots: [CGPoint] = []
    private var finalShape: LineDotsShape?
    private let delegate: any ArtHandler
    
    init(
        _ delegate: any ArtHandler,
        dotRadius: CGFloat
    ) {
        self.delegate = delegate
        self.dotRadius = dotRadius
    }
    
    func draft(_ shape: any Shape) async {
        await delegate.inProgerss(shape)
    }
    
    private func complete(_ finalShape: LineDotsShape) async {
        self.finalShape = finalShape
        await delegate.complete(finalShape)
    }
    
    func addPoint(_ point: CGPoint) async {
        if let finalShape {
            await complete(finalShape)
            return
        }
        
        let rect = CGRect(centroid: .init(x: point.x, y: point.y), width: dotRadius * 2, hedith: dotRadius * 2)
        let dot: CircleShape = .init(rect)
        dots.append(point)
        await draft(dot)
        
        if dots.count == 2 {
            let line = LineDotsShape(dots[0], dots[1], dotRadius: dotRadius)
            await complete(line)
        }
    }
}

//
//  LineDotsShapeFactory.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 21.06.2025.
//

import Foundation

public protocol ArtFactory: Actor {
    func complete() async -> Self
    func setDelegate(_ delegate: ArtHandler?)
}

@MainActor
public protocol ArtHandler: Sendable {
    func inProgerss(_ draft: some Shape)
    func complete(_ shape: some Shape) async
}

public protocol PointFactory: ArtFactory {
    func addPoint(_ point: CGPoint) async
}

public actor DotsShapeFactory<T: Shape>: PointFactory {
    public typealias ShapeFactory = @Sendable (_ points: [CGPoint]) -> T
    public typealias DraftFactory = @Sendable (_ points: CGPoint) -> any Shape
    
    private var points: [CGPoint] = []
    private var finalShape: T?
    private var delegate: ArtHandler?
    private let pointsCount: Int
    private let shapeFactory: ShapeFactory
    private let draftFactory: DraftFactory
    
    public init(
        pointsCount: Int,
        shape: @escaping ShapeFactory,
        draft: @escaping DraftFactory
    ) {
        self.pointsCount = pointsCount
        self.shapeFactory = shape
        self.draftFactory = draft
    }
    
    private func draft(_ shape: some Shape) {
        Task {
            await delegate?.inProgerss(shape)
        }
    }
    
    private func complete(_ finalShape: T) {
        self.finalShape = finalShape
        Task {
            await delegate?.complete(finalShape)
        }
    }
    
    public func complete() async -> Self {
        let factory: Self = .init(pointsCount: pointsCount, shape: shapeFactory, draft: draftFactory)
        let delegate = getDelegate()
        await factory.setDelegate(delegate)
        return factory
    }
    
    private func getDelegate() -> ArtHandler? {
        delegate
    }
    
    public func setDelegate(_ delegate: ArtHandler?) {
        self.delegate = delegate
    }
    
    
    public func addPoint(_ point: CGPoint) {
        draft(draftFactory(point))
        points.append(point)
        if points.count == pointsCount {
            complete(shapeFactory(points))
            finalShape = nil
            return
        }
    }
}

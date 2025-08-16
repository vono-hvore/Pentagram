//
//  PointShapeFactory.swift
//

import UIKit

public enum ShapeState<T: Shape> {
    case final(shape: T)
    case draft(shape: any Shape)
}

@MainActor
public final class PointShapeFactory<T: Shape>: ShapeFactory {
    public typealias FactoryMethod = @Sendable @MainActor (_ points: [CGPoint]) -> ShapeState<T>

    private var points: [CGPoint] = []
    private let shapeFactory: FactoryMethod

    public init(_ shapeFactory: @escaping FactoryMethod) {
        self.shapeFactory = shapeFactory
    }

    public func make(with point: CGPoint, finalShape: Handler, rawDraft: Handler) {
        points.append(point)
        let result = shapeFactory(points)
        switch result {
        case let .final(shape):
            finalShape(shape)
            points.removeAll()
        case let .draft(shape):
            rawDraft(shape)
        }
    }
}

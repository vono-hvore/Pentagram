//
//  ShapeType.swift
//

public typealias AnyShapeSelector = AnyHashable

public protocol ShapeSelector: Hashable {
    var eraseToAnyShapeSelector: AnyShapeSelector { get }
}

public extension ShapeSelector {
    var eraseToAnyShapeSelector: AnyShapeSelector {
        AnyHashable(self)
    }
}

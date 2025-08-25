//
//  ShapeSelector.swift
//

public typealias AnyShapeDescriptor = AnyHashable

public protocol ShapeDescriptor: Hashable {
    var eraseToAnyShapeDescriptor: AnyShapeDescriptor { get }
}

public extension ShapeDescriptor {
    var eraseToAnyShapeDescriptor: AnyShapeDescriptor {
        AnyHashable(self)
    }
}

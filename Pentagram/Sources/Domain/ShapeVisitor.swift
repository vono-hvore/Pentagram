//
//  ShapeVisitor.swift
//

@MainActor
public protocol ShapeVisitor {
    func visitCircleShape(_ shape: CircleShape)

    func visitLineDotsShape(_ shape: LineDotsShape)

    func visitLineShape(_ shape: LineShape)
}

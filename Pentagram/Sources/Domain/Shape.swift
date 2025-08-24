//
//  Shape.swift
//

import CoreGraphics

public protocol Shape: Transformable, Render, Sendable {
    associatedtype ShapeStyle: Style
    var style: ShapeStyle { get }

    func hitTest(_ point: CGPoint) -> Bool
    func setAnchor(at point: CGPoint) -> Self
    func acceptVisitor(_ visitor: ShapeVisitor)
}

@MainActor
public protocol Transformable {
    func move(by delta: CGPoint) -> Self
    func rotate(by radians: CGFloat) -> Self
}

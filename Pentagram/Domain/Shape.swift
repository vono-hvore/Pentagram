//
//  Shape.swift
//

import CoreGraphics

public protocol Shape: Transformable, Render, Sendable {
    associatedtype ShapeStyle: Style
    var style: ShapeStyle { get }
    
    func hitTest(_ point: CGPoint) -> Bool
    mutating func setAnchor(at point: CGPoint) -> Self
}

@MainActor
public protocol Transformable {
    func move(by delta: CGPoint) -> Self
    func rotate(by radians: CGFloat) -> Self
}

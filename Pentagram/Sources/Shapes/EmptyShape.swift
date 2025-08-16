//
//  EmptyShape.swift
//

import Foundation
import CoreGraphics

public struct EmptyShape: Shape {
    public var style: LineShape.LineShapeStyle = .init(
        fillColor: .clear,
        strokeColor: .clear,
        strokeWidth: .zero,
        lineWidth: .zero,
        lineCap: .square,
        lineJoin: .round
    )
    
    public init() {}
    
    public func draw(in context: CGContext) { }
    
    public func hitTest(_ point: CGPoint) -> Bool { false }
    
    public func setAnchor(at point: CGPoint) -> EmptyShape { self }
    
    public func move(by delta: CGPoint) -> EmptyShape { self }
    
    public func rotate(by radians: CGFloat) -> EmptyShape { self }
}

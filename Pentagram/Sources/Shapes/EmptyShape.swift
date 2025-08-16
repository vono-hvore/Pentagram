//
//  EmptyShape.swift
//

import CoreGraphics
import Foundation

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

    public func draw(in _: CGContext) {}

    public func hitTest(_: CGPoint) -> Bool { false }

    public func setAnchor(at _: CGPoint) -> EmptyShape { self }

    public func move(by _: CGPoint) -> EmptyShape { self }

    public func rotate(by _: CGFloat) -> EmptyShape { self }
}

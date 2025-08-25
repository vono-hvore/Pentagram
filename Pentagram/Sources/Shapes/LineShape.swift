//
//  LineShape.swift
//

import UIKit

public struct LineShape: Shape {
    public let id: String = UUID().uuidString
    public let style: LineShapeStyle
    public let start: CGPoint
    public let end: CGPoint
    private let touchThreshold: CGFloat

    public init(
        _ start: CGPoint,
        _ end: CGPoint,
        style: LineShapeStyle,
        touchThreshold: CGFloat = 40
    ) {
        self.start = start
        self.end = end
        self.style = style
        self.touchThreshold = touchThreshold
    }

    public func acceptVisitor(_ visitor: any ShapeVisitor) {
        visitor.visitLineShape(self)
    }

    public func draw(in context: CGContext) {
        context.saveGState()

        context.setLineWidth(style.strokeWidth)
        context.setStrokeColor(style.strokeColor.cgColor)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()

        style.draw(in: context)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()

        context.restoreGState()
    }

    public func hitTest(_ point: CGPoint) -> Bool {
        let distance = CGPoint.distanceFromPointToSegment(point, start, end)
        return distance <= touchThreshold / 2
    }

    public func move(by delta: CGPoint) -> LineShape {
        .init(start + delta, end + delta, style: style)
    }
    
    public func setAnchor(at _: CGPoint) -> Self { self }
    public func rotate(by _: CGFloat) -> LineShape { self }
}

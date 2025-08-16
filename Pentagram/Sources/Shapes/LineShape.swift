//
//  LineShape.swift
//

import UIKit

public struct LineShape: Shape {
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

    public func setAnchor(at _: CGPoint) -> Self { self }

    public func hitTest(_ point: CGPoint) -> Bool {
        let distance = CGPoint.distanceFromPointToSegment(point, start, end)
        return distance <= touchThreshold / 2
    }

    public func rotate(by _: CGFloat) -> LineShape { self }

    public func move(by delta: CGPoint) -> LineShape {
        .init(start + delta, end + delta, style: style)
    }
}

// MARK: - Style

public extension LineShape {
    struct LineShapeStyle: HasFillStyle, HasStrokeStyle, HasLineStyle {
        public let fillColor: UIColor
        public let lineWidth: CGFloat
        public let strokeColor: UIColor
        public let strokeWidth: CGFloat
        public let lineCap: CGLineCap
        public let lineJoin: CGLineJoin

        public init(
            fillColor: UIColor,
            strokeColor: UIColor,
            strokeWidth: CGFloat,
            lineWidth: CGFloat,
            lineCap: CGLineCap,
            lineJoin: CGLineJoin
        ) {
            self.fillColor = fillColor
            self.lineWidth = lineWidth
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
            self.lineCap = lineCap
            self.lineJoin = lineJoin
        }
    }
}

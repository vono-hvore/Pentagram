//
//  CircleShape.swift
//

import UIKit

public struct CircleShape: Shape {
    public let style: CircleShapeStyle
    private let rect: CGRect

    public init(_ rect: CGRect, style: CircleShapeStyle = .default) {
        self.rect = rect
        self.style = style
    }

    public func draw(in context: CGContext) {
        context.saveGState()

        style.draw(in: context)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)

        context.restoreGState()
    }

    public func hitTest(_ point: CGPoint) -> Bool {
        rect.contains(point)
    }

    public func setAnchor(at _: CGPoint) -> Self { self }

    public func rotate(by _: CGFloat) -> Self { self }

    public func move(by delta: CGPoint) -> CircleShape {
        .init(
            .init(
                centroid: rect.origin + delta,
                width: rect.width,
                height: rect.height
            ),
            style: style
        )
    }
}

// MARK: - Style

public extension CircleShape {
    struct CircleShapeStyle: HasFillStyle, HasStrokeStyle {
        public let fillColor: UIColor
        public let strokeColor: UIColor
        public let strokeWidth: CGFloat

        public init(
            fillColor: UIColor,
            strokeColor: UIColor,
            strokeWidth: CGFloat
        ) {
            self.fillColor = fillColor
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
        }
    }
}

public extension CircleShape.CircleShapeStyle {
    static var `default`: Self {
        .init(
            fillColor: .red,
            strokeColor: .black,
            strokeWidth: 1
        )
    }
}

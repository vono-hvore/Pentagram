//
//  CustomShape.swift
//

import PentagramFramework
import UIKit

protocol ShapeVisitorExtended: ShapeVisitor {
    func visitCustomShape(_ shape: CustomShape)
}

public struct CustomShape: Shape {
    public let style: CircleShape.CircleShapeStyle
    private let rect: CGRect

    public init(_ rect: CGRect, style: CircleShape.CircleShapeStyle = .default) {
        self.rect = rect
        self.style = style
    }

    public func acceptVisitor(_ visitor: any ShapeVisitor) {
        guard let visitor = visitor as? ShapeVisitorExtended else { return }

        visitor.visitCustomShape(self)
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

    public func move(by delta: CGPoint) -> CustomShape {
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

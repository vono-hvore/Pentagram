//
//  CustomShape.swift
//

import PentagramFramework
import CoreGraphics

protocol ShapeVisitorExtended: ShapeVisitor {
    func visitCustomShape(_ shape: CustomShape)
}

struct CustomShape: Shape {
    public let style: CircleShape.CircleShapeStyle
    private let rect: CGRect

    public init(_ rect: CGRect, style: CircleShape.CircleShapeStyle = .default) {
        self.rect = rect
        self.style = style
    }

    func acceptVisitor(_ visitor: any ShapeVisitor) {
        guard let visitor = visitor as? ShapeVisitorExtended else { return }

        visitor.visitCustomShape(self)
    }

    func draw(in context: CGContext) {
        context.saveGState()

        style.draw(in: context)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)

        context.restoreGState()
    }

    func hitTest(_ point: CGPoint) -> Bool {
        rect.contains(point)
    }

    func setAnchor(at _: CGPoint) -> Self { self }

    func rotate(by _: CGFloat) -> Self { self }

    func move(by delta: CGPoint) -> CustomShape {
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

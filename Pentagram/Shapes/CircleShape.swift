//
//  DotShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

struct CircleShape: Shape, Render, Transformable {
    let id: UUID = UUID()
    let style: CircleShapeStyle
    let rect: CGRect
    
    init(
        _ rect: CGRect,
        style: ShapeStyle = CircleShapeStyle()
    ) {
        self.rect = rect
        self.style = style
    }
    
    func tranform(_ transform: Transform) -> Self {
        .init(rect, style: style)
    }
    
    func render(in context: CGContext) {
        context.saveGState()
        
        style.render(in: context)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)
        
        context.restoreGState()
    }
}

// MARK: - Style

extension CircleShape {
    struct CircleShapeStyle: HasFillStyle, HasStrokeStyle {
        public let color: UIColor
        public let strokeColor: UIColor
        public let strokeWidth: CGFloat
        
        public init() {
            self.init(
                color: .red,
                strokeColor: .black,
                strokeWidth: 1
            )
        }
        
        public init(
            color: UIColor,
            strokeColor: UIColor,
            strokeWidth: CGFloat
        ) {
            self.color = color
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
        }
    }
}

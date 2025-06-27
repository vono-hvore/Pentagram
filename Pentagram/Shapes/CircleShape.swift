//
//  DotShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

public struct CircleShape: Shape {
    public let style: CircleShapeStyle
    let rect: CGRect
    
    public init(
        _ rect: CGRect,
        style: CircleShapeStyle = CircleShapeStyle()
    ) {
        self.rect = rect
        self.style = style
    }
    
    public func move(by point: CGPoint) -> CircleShape {
        .init(rect, style: style)
    }
    
    public func render(in context: CGContext) {
        context.saveGState()
        
        style.render(in: context)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)
        
        context.restoreGState()
    }
    
    public func hitTest(_ point: CGPoint) -> Bool {
        rect.contains(point)
    }
    
    public func setAnchor(at point: CGPoint) -> Self {
        self
    }
    
    public func rotate(by radians: CGFloat) -> Self {
        self
    }
    
    func scale(by delta: CGFloat) -> Self {
        self
    }
}

// MARK: - Style

public extension CircleShape {
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

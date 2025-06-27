//
//  LineShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 05.06.2025.
//

import UIKit
import QuartzCore

public struct LineShape: Shape {
    let id: UUID = UUID()
    public let style: LineShapeStyle
    private let start: CGPoint
    private let end: CGPoint
    
    public init(
        _ start: CGPoint,
        _ end: CGPoint,
        style: LineShapeStyle = LineShapeStyle()
    ) {
        self.start = start
        self.end = end
        self.style = style
    }
    
    public func move(by point: CGPoint) -> LineShape {
        .init(start, end, style: style)
    }
    
    public func render(in context: CGContext) {
        context.saveGState()
        
        style.stroke.render(in: context)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()

        style.render(in: context)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
        
        context.restoreGState()
    }
    
    public func setAnchor(at point: CGPoint) -> Self {
        return self
    }
    
    public func hitTest(_ point: CGPoint) -> Bool {
        CGPoint.distance(start, point) == CGPoint.distance(end, point)
    }
    
    public func rotate(by radians: CGFloat) -> LineShape {
        self
    }
    
    public func scale(by delta: CGFloat) -> LineShape {
        self
    }
}

// MARK: - Style

public extension LineShape {
    struct LineShapeStyle: HasFillStyle, HasStrokeStyle, HasLineStyle {
        public struct LineShapStrokeStyle: HasStrokeStyle {
            public let strokeColor: UIColor
            public let strokeWidth: CGFloat
            
            public init(strokeColor: UIColor = .black, strokeWidth: CGFloat = 5) {
                self.strokeColor = strokeColor
                self.strokeWidth = strokeWidth
            }
        }
        
        let lineWidth: CGFloat
        let stroke: LineShapStrokeStyle
        public let color: UIColor
        public var strokeColor: UIColor { color }
        public var strokeWidth: CGFloat { lineWidth }
        public let lineCap: CGLineCap
        public let lineJoin: CGLineJoin
        
        public init(
            color: UIColor = .red,
            strokeColor: UIColor = .black,
            lineWitdh: CGFloat = 3,
            strokeWidth: CGFloat = 2,
            lineCap: CGLineCap = .round,
            lineJoin: CGLineJoin = .round
        ) {
            self.color = color
            self.stroke = .init(strokeColor: strokeColor, strokeWidth: lineWitdh + strokeWidth)
            self.lineWidth = lineWitdh
            self.lineCap = lineCap
            self.lineJoin = lineJoin
        }
    }
}

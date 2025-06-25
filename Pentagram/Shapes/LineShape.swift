//
//  LineShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 05.06.2025.
//

import UIKit
import QuartzCore

struct LineShape: Shape {
    let id: UUID = UUID()
    let style: LineShapeStyle
    let transform: Transform = .identity
    private let start: CGPoint
    private let end: CGPoint
    
    init(
        _ start: CGPoint,
        _ end: CGPoint,
        style: ShapeStyle = LineShapeStyle()
    ) {
        self.start = start
        self.end = end
        self.style = style
    }
    
    func tranform(_ transform: Transform) -> Self {
        .init(start, end, style: style)
    }
    
    func move(by point: CGPoint) -> LineShape {
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
    
    func anchor(at point: CGPoint) -> Self {
        return self
    }
    
    func hitTest(_ point: CGPoint) -> Bool {
        CGPoint.distance(start, point) == CGPoint.distance(end, point)
    }
    
    func rotate(by radians: CGFloat) -> LineShape {
        self
    }
    
    func scale(by delta: CGFloat) -> LineShape {
        self
    }
}

// MARK: - Style

extension LineShape {
    struct LineShapeStyle: HasFillStyle, HasStrokeStyle, HasLineStyle {
        struct LineShapStrokeStyle: HasStrokeStyle {
            let strokeColor: UIColor
            let strokeWidth: CGFloat
            
            init(strokeColor: UIColor = .black, strokeWidth: CGFloat = 5) {
                self.strokeColor = strokeColor
                self.strokeWidth = strokeWidth
            }
        }
        
        let color: UIColor
        let lineWidth: CGFloat
        var strokeColor: UIColor { color }
        var strokeWidth: CGFloat { lineWidth }
        let stroke: LineShapStrokeStyle
        let lineCap: CGLineCap
        let lineJoin: CGLineJoin
        
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

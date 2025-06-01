//
//  LineDotsShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

struct LineDotsShape: Shape, Render, Transformable {
    let id: UUID = UUID()
    let style: LineDotsShapeStyle
    private let dotRadius: CGFloat
    private let start: CGPoint
    private let end: CGPoint
    
    init(
        _ start: CGPoint,
        _ end: CGPoint,
        dotRadius: CGFloat,
        style: ShapeStyle = LineDotsShapeStyle()
    ) {
        self.start = start
        self.end = end
        self.dotRadius = dotRadius
        self.style = style
    }
    
    func tranform(_ transform: Transform) -> Self {
        .init(start, end, dotRadius: dotRadius, style: style)
    }
    
    func render(in context: CGContext) {
        context.saveGState()
        style.lineStyle.stroke.render(in: context)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
        
        style.lineStyle.render(in: context)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
        context.restoreGState()
        
        context.saveGState()
        var rect = CGRect(centroid: start, width: dotRadius * 2, hedith: dotRadius * 2)
        style.circleStyle.render(in: context)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
        
        context.saveGState()
        rect = CGRect(centroid: end, width: dotRadius * 2, hedith: dotRadius * 2)
        style.circleStyle.render(in: context)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
    }
}

extension LineDotsShape {
    struct LineDotsShapeStyle: Style {
        let lineStyle: LineShape.LineShapeStyle
        let circleStyle: CircleShape.CircleShapeStyle
        
        init(
            lineStyle: LineShape.LineShapeStyle = .init(),
            circleStyle: CircleShape.CircleShapeStyle = .init()
        ) {
            self.lineStyle = lineStyle
            self.circleStyle = circleStyle
        }
    }
}

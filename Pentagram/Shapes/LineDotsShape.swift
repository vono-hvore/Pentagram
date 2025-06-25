//
//  LineDotsShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

struct LineDotsShape: Shape {
    let id: UUID = UUID()
    let style: LineDotsShapeStyle
    let transform: Transform = .identity
    private let anchor: Anchor // CGLayerAnchor, // Maybe anchor need to be moved to transform
    private let dotRadius: CGFloat
    private let start: CGPoint
    private let end: CGPoint
    
    init(
        _ start: CGPoint,
        _ end: CGPoint,
        dotRadius: CGFloat,
        anchor: Anchor = .line,
        style: ShapeStyle = LineDotsShapeStyle()
    ) {
        self.anchor = anchor
        self.start = start
        self.end = end
        self.dotRadius = dotRadius
        self.style = style
    }
    
    func tranform(_ transform: Transform) -> Self {
        .init(
            start.applying(transform),
            end.applying(transform),
            dotRadius: dotRadius,
            style: style
        )
    }
    
    func move(by delta: CGPoint) -> Self {
        return switch anchor {
        case .startDot:
                .init(
                    start.applying(transform.translated(by: delta)),
                    end,
                    dotRadius: dotRadius,
                    anchor: anchor,
                    style: style
                )
        case .endDot:
                .init(
                    start,
                    end.applying(transform.translated(by: delta)),
                    dotRadius: dotRadius,
                    anchor: anchor,
                    style: style
                )
        case .line:
            tranform(transform.translated(by: delta))
        }
    }
    
    func rotate(by radians: CGFloat) -> Self {
        let middlePoint = CGPoint.middlePoint(start, end)
        return .init(
            start.applying(CGAffineTransform
                .identity
                .translatedBy(x: middlePoint.x, y: middlePoint.y)
                .rotated(by: transform.rotation + radians)
                .translatedBy(x: -middlePoint.x, y: -middlePoint.y)
            ),
            end.applying(CGAffineTransform
                .identity
                .translatedBy(x: middlePoint.x, y: middlePoint.y)
                .rotated(by: transform.rotation + radians)
                .translatedBy(x: -middlePoint.x, y: -middlePoint.y)
            ),
            dotRadius: dotRadius,
            style: style
        )
    }
    
    func scale(by delta: CGFloat) -> Self {
        .init(
            CGPoint(x: start.x + delta, y: start.y + delta),
            CGPoint(x: end.x + delta, y: end.y + delta),
            dotRadius: dotRadius,
            anchor: anchor,
            style: style
        )
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
    
    func hitTest(_ point: CGPoint) -> Bool {
        anchor(at: point) != nil
    }
    
    func anchor(at point: CGPoint) -> Self {
        guard let newAnchor = anchor(at: point) else { return self }
        return .init(start, end, dotRadius: dotRadius, anchor: newAnchor, style: style)
    }
    
    func anchor(at point: CGPoint) -> Anchor? {
        let startRect = CGRect(
            centroid: start,
            width: dotRadius * 2 + 40,
            hedith: dotRadius * 2 + 40
        )
        let endRect = CGRect(
            centroid: end,
            width: dotRadius * 2 + 40,
            hedith: dotRadius * 2 + 40
        )
        if startRect.contains(point) {
            return .startDot
        }
        if endRect.contains(point) {
            return .endDot
        }
        // Check if point is close enough to the line segment
        let lineWidth = style.lineStyle.lineWidth
        let threshold = max(lineWidth, 40)
        let distance = distanceFromPointToSegment(point, start, end)
        if distance <= threshold / 2 {
            return .line
        }
        
        return nil
    }
    
    // Helper: Distance from point to line segment
    private func distanceFromPointToSegment(_ p: CGPoint, _ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let ab = b - a
        let ap = p - a
        let abLengthSquared = ab.x * ab.x + ab.y * ab.y
        if abLengthSquared == 0 { return CGPoint.distance(a, p) }
        let t = max(0, min(1, ((ap.x * ab.x + ap.y * ab.y) / abLengthSquared)))
        let projection = CGPoint(x: a.x + ab.x * t, y: a.y + ab.y * t)
        return CGPoint.distance(p, projection)
    }
}

// MARK: - Anchor

extension LineDotsShape {
    enum Anchor {
        case startDot
        case endDot
        case line
    }
}

// MARK: - Style

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

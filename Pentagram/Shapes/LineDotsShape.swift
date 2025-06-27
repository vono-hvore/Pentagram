//
//  LineDotsShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import UIKit

// TODO:
// 1. Does anchor must be a part of the shape?
// 2. Think about LazyWrapper for Shape
// 3. Does i need COW here?

public struct LineDotsShape: Shape {
    public let start: CGPoint
    public let end: CGPoint
    public let style: LineDotsShapeStyle
    public let anchor: Anchor
    private let transform: CGAffineTransform = .identity
    private let dotRadius: CGFloat
    
    public init(
        _ start: CGPoint,
        _ end: CGPoint,
        dotRadius: CGFloat,
        anchor: Anchor = .line(.zero),
        style: LineDotsShapeStyle = .init()
    ) {
        self.anchor = anchor
        self.start = start
        self.end = end
        self.dotRadius = dotRadius
        self.style = style
    }
    
    public func render(in context: CGContext) {
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
    
    public func hitTest(_ point: CGPoint) -> Bool {
        findAnchor(at: point) != nil
    }
    
    public func setAnchor(at point: CGPoint) -> Self {
        guard let newAnchor = findAnchor(at: point) else { return self }
        
        return .init(start, end, dotRadius: dotRadius, anchor: newAnchor, style: style)
    }
    
    private func findAnchor(at point: CGPoint) -> Anchor? {
        var threshold: CGFloat = 25
        let startRect = CGRect(
            centroid: start,
            width: dotRadius * 2 + threshold,
            hedith: dotRadius * 2 + threshold
        )
        let endRect = CGRect(
            centroid: end,
            width: dotRadius * 2 + threshold,
            hedith: dotRadius * 2 + threshold
        )
        if startRect.contains(point) {
            return .startDot(point)
        }
        if endRect.contains(point) {
            return .endDot(point)
        }
        let lineWidth = style.lineStyle.lineWidth
        threshold = max(lineWidth, 40)
        let distance = distanceFromPointToSegment(point, start, end)
        if distance <= threshold / 2 {
            return .line(point)
        }
        
        return nil
    }
    
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

// MARK: - Transform

public extension LineDotsShape {
    func move(by delta: CGPoint) -> Self {
        return switch anchor {
        case .startDot:
                .init(
                    start.applying(
                        transform.translated(by: delta)
                    ),
                    end,
                    dotRadius: dotRadius,
                    anchor: anchor,
                    style: style
                )
        case .endDot:
                .init(
                    start,
                    end.applying(
                        transform.translated(by: delta)
                    ),
                    dotRadius: dotRadius,
                    anchor: anchor,
                    style: style
                )
        case .line:
                .init(
                    start.applying(
                        transform.translated(by: delta)
                    ),
                    end.applying(
                        transform.translated(by: delta)
                    ),
                    dotRadius: dotRadius,
                    style: style
                )
        }
    }
    
    func rotate(by radians: CGFloat) -> Self {
        let middlePoint: CGPoint = .middlePoint(start, end)
        return .init(
            start.applying(
                transform
                    .translated(by: middlePoint)
                    .rotated(by: radians)
                    .translated(by: -middlePoint)
            ),
            end.applying(
                transform
                    .translated(by: middlePoint)
                    .rotated(by: radians)
                    .translated(by: -middlePoint)
            ),
            dotRadius: dotRadius,
            style: style
        )
    }
}

// MARK: - Anchor

public extension LineDotsShape {
    enum Anchor: Sendable {
        case startDot(CGPoint)
        case endDot(CGPoint)
        case line(CGPoint)
    }
}

// MARK: - Style

public extension LineDotsShape {
    struct LineDotsShapeStyle: Style {
        public let lineStyle: LineShape.LineShapeStyle
        public let circleStyle: CircleShape.CircleShapeStyle
        
        public init(
            lineStyle: LineShape.LineShapeStyle = .init(),
            circleStyle: CircleShape.CircleShapeStyle = .init()
        ) {
            self.lineStyle = lineStyle
            self.circleStyle = circleStyle
        }
    }
}

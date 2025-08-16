//
//  LineDotsShape.swift
//

import UIKit

public struct LineDotsShape: Shape {
    public let start: CGPoint
    public let end: CGPoint
    public let style: LineDotsShapeStyle
    public var anchor: Anchor
    private let transform: CGAffineTransform = .identity
    private let dotRadius: CGFloat
    private let touchThreshold: CGFloat = 24
    
    public init(
        _ start: CGPoint,
        _ end: CGPoint,
        dotRadius: CGFloat,
        anchor: Anchor = .line(.zero),
        style: LineDotsShapeStyle = .default
    ) {
        self.anchor = anchor
        self.start = start
        self.end = end
        self.dotRadius = dotRadius
        self.style = style
    }
    
    private init(copy: Self) {
        self.anchor = copy.anchor
        self.start = copy.start
        self.end = copy.end
        self.dotRadius = copy.dotRadius
        self.style = copy.style
    }
    
    public func draw(in context: CGContext) {
        context.saveGState()
        context.setLineWidth(style.lineStyle.lineWidth)
        context.setStrokeColor(style.lineStyle.strokeColor.cgColor)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
        
        style.lineStyle.draw(in: context)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
        context.restoreGState()
        
        context.saveGState()
        var rect = CGRect(centroid: start, width: dotRadius * 2, height: dotRadius * 2)
        style.circleStyle.draw(in: context)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
        
        context.saveGState()
        rect = CGRect(centroid: end, width: dotRadius * 2, height: dotRadius * 2)
        style.circleStyle.draw(in: context)
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
}

// MARK: - Transform

public extension LineDotsShape {
    func move(by delta: CGPoint) -> Self {
        return switch anchor {
        case .startDot: .init(
            start.applying(transform.translated(by: delta)),
            end,
            dotRadius: dotRadius,
            anchor: anchor,
            style: style
        )
        case .endDot: .init(
            start,
            end.applying(transform.translated(by: delta)),
            dotRadius: dotRadius,
            anchor: anchor,
            style: style
        )
        case .line: .init(
            start.applying(transform.translated(by: delta)),
            end.applying(transform.translated(by: delta)),
            dotRadius: dotRadius,
            style: style
        )
        }
    }
    
    func rotate(by radians: CGFloat) -> Self {
        let middlePoint = CGPoint.middlePoint(start, end)
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
    
    private func findAnchor(at point: CGPoint) -> Anchor? {
        let startRect = CGRect(
            centroid: start,
            width: dotRadius * 2 + touchThreshold,
            height: dotRadius * 2 + touchThreshold
        )
        let endRect = CGRect(
            centroid: end,
            width: dotRadius * 2 + touchThreshold,
            height: dotRadius * 2 + touchThreshold
        )
        if startRect.contains(point) {
            return .startDot(point)
        }
        if endRect.contains(point) {
            return .endDot(point)
        }
        let lineWidth = style.lineStyle.lineWidth
        let threshold = max(lineWidth, touchThreshold)
        let distance = CGPoint.distanceFromPointToSegment(point, start, end)
        if distance <= threshold {
            return .line(point)
        }
        
        return nil
    }
}

// MARK: - Style

public extension LineDotsShape {
    struct LineDotsShapeStyle: Style {
        public let lineStyle: LineShape.LineShapeStyle
        public let circleStyle: CircleShape.CircleShapeStyle
        
        public init(
            lineStyle: LineShape.LineShapeStyle,
            circleStyle: CircleShape.CircleShapeStyle
        ) {
            self.lineStyle = lineStyle
            self.circleStyle = circleStyle
        }
    }
}

public extension LineDotsShape.LineDotsShapeStyle {
    static var `default`: Self {
        .init(lineStyle: .init(fillColor: .red, strokeColor: .black, strokeWidth: 4, lineWidth: 4, lineCap: .round, lineJoin: .round), circleStyle: .default)
    }
}

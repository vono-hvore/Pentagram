//
//  LineDotsImageShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 26.06.2025.
//

import Pentagram
import UIKit

struct LineDotsImageShape: Shape {
    let style: LineDotsShape.LineDotsShapeStyle
    
    private let image: String
    private let anchor: LineDotsShape.Anchor
    private let lineDotsShape: LineDotsShape
    private let start: CGPoint
    private let end: CGPoint
    private let dotRadius: CGFloat
    private let showLabels: Bool
    private let startLabel: String
    private let endLabel: String
    private let labelFont: UIFont
    private let labelColor: UIColor
    
    init(
        _ start: CGPoint,
        _ end: CGPoint,
        dotRadius: CGFloat = 7,
        image: String,
        anchor: LineDotsShape.Anchor = .line(.zero),
        style: LineDotsShape.LineDotsShapeStyle = .init(),
        showLabels: Bool = true,
        startLabel: String = "A",
        endLabel: String = "B",
        labelFont: UIFont = .systemFont(ofSize: 14, weight: .bold),
        labelColor: UIColor = .black
    ) {
        self.start = start
        self.end = end
        self.image = image
        self.style = style
        self.dotRadius = dotRadius
        self.anchor = anchor
        self.showLabels = showLabels
        self.startLabel = startLabel
        self.endLabel = endLabel
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.lineDotsShape = .init(start, end, dotRadius: dotRadius, anchor: anchor, style: style)
    }
    
    func render(in context: CGContext) {
        lineDotsShape.render(in: context)
        drawImageAlongLine(in: context)
        if showLabels {
            drawEndpointLabels(in: context)
        }
    }
    
    func hitTest(_ point: CGPoint) -> Bool {
        lineDotsShape.hitTest(point)
    }
    
    func setAnchor(at point: CGPoint) -> LineDotsImageShape {
        let shape = lineDotsShape.setAnchor(at: point)
        return .init(
            start, end, 
            dotRadius: dotRadius, 
            image: image, 
            anchor: shape.anchor, 
            style: style,
            showLabels: showLabels,
            startLabel: startLabel,
            endLabel: endLabel,
            labelFont: labelFont,
            labelColor: labelColor
        )
    }
    
    func move(by delta: CGPoint) -> LineDotsImageShape {
        let shape = lineDotsShape.move(by: delta)
        
        return .init(
            shape.start, shape.end, 
            dotRadius: dotRadius, 
            image: image, 
            anchor: anchor, 
            style: style,
            showLabels: showLabels,
            startLabel: startLabel,
            endLabel: endLabel,
            labelFont: labelFont,
            labelColor: labelColor
        )
    }
    
    func rotate(by radians: CGFloat) -> LineDotsImageShape {
        let shape = lineDotsShape.rotate(by: radians)
        
        return .init(
            shape.start, shape.end, 
            dotRadius: dotRadius, 
            image: image, 
            anchor: anchor, 
            style: style,
            showLabels: showLabels,
            startLabel: startLabel,
            endLabel: endLabel,
            labelFont: labelFont,
            labelColor: labelColor
        )
    }
    
    func drawImageAlongLine(in context: CGContext) {
        guard let image = UIImage(systemName: image) else { return }
        context.saveGState()

        let dx = end.x - start.x
        let dy = end.y - start.y
        let angle = atan2(dy, dx)
        let imageSize = image.size
        let middlePoint = CGPoint.middlePoint(start, end)
        context.translateBy(x: middlePoint.x, y: middlePoint.y)
        context.rotate(by: angle + .pi / 2)
        let rect = CGRect(x: -imageSize.width / 2, y: -imageSize.height / 2, width: imageSize.width, height: imageSize.height)
        context.setFillColor(UIColor.red.cgColor)
        context.fill(rect)
        if let cgImage = image.cgImage {
            context.saveGState()
            context.clip(to: rect, mask: cgImage)
            context.setFillColor(UIColor.white.cgColor)
            context.fill(rect)
            context.restoreGState()
        }

        context.restoreGState()
    }
    
    func drawEndpointLabels(in context: CGContext) {
        context.saveGState()
        
        let dx = end.x - start.x
        let dy = end.y - start.y
        let middlePoint = CGPoint.middlePoint(start, end)
        let rotationAngle = atan2(dy, dx) + .pi / 2
        let offset: CGFloat = dotRadius * 2.5 + 20
        
        let startLabelPoint = CGPoint(
            x: middlePoint.x - offset * cos(rotationAngle),
            y: middlePoint.y - offset * sin(rotationAngle)
        )
        drawLabel(startLabel, at: startLabelPoint, in: context)
        
        let endLabelPoint = CGPoint(
            x: middlePoint.x + offset * cos(rotationAngle),
            y: middlePoint.y + offset * sin(rotationAngle)
        )
        drawLabel(endLabel, at: endLabelPoint, in: context)
        
        context.restoreGState()
    }
    
    private func drawLabel(_ text: String, at point: CGPoint, in context: CGContext) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: labelColor
        ]
        
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: point.x - textSize.width / 2,
            y: point.y - textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
    }
}

private extension CGContext {
    func drawText(_ text: String, at point: CGPoint, attributes: [NSAttributedString.Key: Any]) {
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: point)
    }
}

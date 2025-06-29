//
//  ShapeStyle.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 05.06.2025.
//

import UIKit

public protocol Style: Render {}

public protocol HasFillStyle: Style {
    var color: UIColor { get }
}

public protocol HasLineStyle: Style {
    var lineJoin: CGLineJoin { get }
    var lineCap: CGLineCap { get }
}

public protocol HasStrokeStyle: Style {
    var strokeColor: UIColor { get }
    var strokeWidth: CGFloat { get }
}

public protocol HasDashPattern: Style {
    var phase: CGFloat { get }
    var lengths: [CGFloat] { get }
}

public extension Style {
    func render(in context: CGContext) {
        if case let style as HasFillStyle = self {
            context.setFillColor(style.color.cgColor)
        }
        
        if case let style as HasStrokeStyle = self {
            context.setLineWidth(style.strokeWidth)
            context.setStrokeColor(style.strokeColor.cgColor)
        }

        if case let style as HasLineStyle = self {
            context.setLineCap(style.lineCap)
            context.setLineJoin(style.lineJoin)
        }
        
        if case let style as HasDashPattern = self {
            context.setLineDash(phase: style.phase, lengths: style.lengths)
        }
    }
}

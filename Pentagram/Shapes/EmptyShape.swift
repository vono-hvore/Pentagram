//
//  EmptyShape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 28.06.2025.
//

import Foundation
import CoreGraphics

public struct EmptyShape: Shape {
    public var style: LineShape.LineShapeStyle = .init()
    
    public func hitTest(_ point: CGPoint) -> Bool { false }
    
    public func setAnchor(at point: CGPoint) -> EmptyShape { self }
    
    public func move(by delta: CGPoint) -> EmptyShape { self }
    
    public func rotate(by radians: CGFloat) -> EmptyShape { self }
    
    public func render(in context: CGContext) { }
}

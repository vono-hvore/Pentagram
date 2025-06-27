//
//  Shape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import Foundation

public protocol Shape: Transformable, Render, Sendable {
    associatedtype ShapeStyle: Style
    var style: ShapeStyle { get }
    
    func hitTest(_ point: CGPoint) -> Bool
    func setAnchor(at point: CGPoint) -> Self
}

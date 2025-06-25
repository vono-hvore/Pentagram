//
//  Shape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

import Foundation

protocol Shape:
    Transformable,
    Render,
    Identifiable {
    associatedtype ShapeStyle: Style
    
    var style: ShapeStyle { get }
    
    func hitTest(_ point: CGPoint) -> Bool
    func anchor(at point: CGPoint) -> Self
}

//
//  ShapeContainer.swift
//

import CoreGraphics
import UIKit

@MainActor
struct ShapeContainer {
    private(set) var shapes: [any Shape] = []
    private var anchor: CGPoint = .zero
    private var rotation: CGFloat = .zero
    
    var containsShapes: Bool { !shapes.isEmpty }
    
    func draw(in context: CGContext) {
        shapes.forEach { $0.draw(in: context) }
    }
    
    func contains(point: CGPoint) -> Bool {
        shapes.contains { $0.hitTest(point) }
    }
    
    mutating func add(shape: some Shape) {
        shapes.append(shape)
    }
    
    mutating func eraseAll() {
        shapes.removeAll()
    }
    
    mutating func setAnchor(at point: CGPoint) {
        anchor = point
        rotation = .zero
        shapes = shapes.map { shape in
            var newShape = shape
            return newShape.setAnchor(at: point)
        }
    }
    
    mutating func move(to point: CGPoint) {
        guard anchor != .zero else { return }
        
        shapes = shapes.map { $0.move(by: point - anchor) }
        anchor = point
    }
    
    mutating func rotate(by radians: CGFloat) {
        shapes = shapes.map { $0.rotate(by: radians - rotation) }
        rotation = radians
    }
}

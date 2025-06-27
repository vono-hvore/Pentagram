//
//  Picasso.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 21.06.2025.
//

import CoreGraphics

struct Picasso {
    private(set) var shapes: [any Shape] = []
    private var anchor: CGPoint = .zero
    private var rotation: CGFloat = .zero
    
    var containsShapes: Bool {
        !shapes.isEmpty
    }
    
    func draw(in context: CGContext) {
        shapes.forEach { $0.render(in: context) }
    }
    
    func contains(_ point: CGPoint) -> Bool {
        shapes.contains { $0.hitTest(point) }
    }
    
    mutating func order(_ shape: some Shape) {
        shapes.append(shape)
    }
    
    mutating func erase() {
        shapes.removeAll()
    }
    
    mutating func setAnchor(_ point: CGPoint) {
        anchor = point
        rotation = .zero
        shapes = shapes.map { $0.setAnchor(at: point) }
    }
    
    mutating func move(to point: CGPoint) {
        guard anchor != .zero else { return }
        
        shapes = shapes.map { $0.move(by: point - anchor)}
        anchor = point
    }
    
    mutating func rotate(by radians: CGFloat) {
        shapes = shapes.map { $0.rotate(by: radians - rotation)}
        rotation = radians
    }
}

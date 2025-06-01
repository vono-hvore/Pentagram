//
//  Picasso.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 21.06.2025.
//

import CoreGraphics

struct Picasso {
    private var shapes: [any Render] = []
    
    mutating func order(_ shape: any Shape) {
        shapes.append(shape)
    }
    
    mutating func erase() {
        shapes.removeAll()
    }
    
    func draw(in context: CGContext) {
        shapes.forEach { $0.render(in: context) }
    }
}

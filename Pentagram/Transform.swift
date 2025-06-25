//
//  Transform.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 19.06.2025.
//

import Foundation

protocol Transformable {
    // var rect
    var transform: Transform { get }
    func tranform(_ transform: Transform) -> Self
    func move(by point: CGPoint) -> Self // calculate it by rect
    func rotate(by radians: CGFloat) -> Self
    func scale(by delta: CGFloat) -> Self
}

struct Transform {
    let translation: CGPoint
    let rotation: CGFloat
    let scale: CGFloat
}

extension Transform {
    static let identity: Self = .init(translation: .zero, rotation: .zero, scale: 1)
}

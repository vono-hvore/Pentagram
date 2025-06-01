//
//  Transform.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 19.06.2025.
//

import Foundation

protocol Transformable {
    func tranform(_ transform: Transform) -> Self
}

struct Transform {
    let translation: CGPoint
    let rotation: CGFloat
    let scale: CGFloat
}

extension Transform {
    static let identity: Self = .init(translation: .zero, rotation: .zero, scale: 1)
}

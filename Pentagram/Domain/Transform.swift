//
//  Transform.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 19.06.2025.
//

import Foundation

public protocol Transformable {
    func move(by delta: CGPoint) -> Self
    func rotate(by radians: CGFloat) -> Self
}

//
//  Transform.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 19.06.2025.
//

import Foundation

protocol Transformable {
    // var rect
    //var transform: Transform { get }
    //func tranform(_ transform: Transform) -> Self
    func move(by delta: CGPoint) -> Self // calculate it by rect
    func rotate(by radians: CGFloat) -> Self
}

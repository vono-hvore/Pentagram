//
//  Render.swift
//

import CoreGraphics

@MainActor
public protocol Render: Sendable {
    func draw(in context: CGContext)
}

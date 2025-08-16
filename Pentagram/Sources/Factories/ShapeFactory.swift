//
//  ShapeFactory.swift
//

import CoreGraphics

@MainActor
public protocol ShapeFactory {
    typealias Handler = @Sendable @MainActor (_ shape: any Shape) -> Void

    func make(with point: CGPoint, finalShape: Handler, rawDraft: Handler)
}

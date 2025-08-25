//
//  CircleShape+ShapeStyle.swift
//

import UIKit

public extension CircleShape {
    struct CircleShapeStyle: HasFillStyle, HasStrokeStyle {
        public let fillColor: UIColor
        public let strokeColor: UIColor
        public let strokeWidth: CGFloat

        public init(
            fillColor: UIColor,
            strokeColor: UIColor,
            strokeWidth: CGFloat
        ) {
            self.fillColor = fillColor
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
        }
    }
}

public extension CircleShape.CircleShapeStyle {
    static var `default`: Self {
        .init(
            fillColor: .red,
            strokeColor: .black,
            strokeWidth: 1
        )
    }
}

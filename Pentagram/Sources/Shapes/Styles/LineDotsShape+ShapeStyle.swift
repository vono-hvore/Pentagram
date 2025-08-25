//
//  LineDotsShape+ShapeStyle.swift
//

import UIKit

public extension LineDotsShape {
    struct LineDotsShapeStyle: Style {
        public let lineStyle: LineShape.LineShapeStyle
        public let circleStyle: CircleShape.CircleShapeStyle

        public init(
            lineStyle: LineShape.LineShapeStyle,
            circleStyle: CircleShape.CircleShapeStyle
        ) {
            self.lineStyle = lineStyle
            self.circleStyle = circleStyle
        }
    }
}

public extension LineDotsShape.LineDotsShapeStyle {
    static var `default`: Self {
        .init(
            lineStyle: .init(
                fillColor: .red,
                strokeColor: .black,
                strokeWidth: 4,
                lineWidth: 4,
                lineCap: .round,
                lineJoin: .round
            ),
            circleStyle: .default
        )
    }
}

//
//  LineShape+ShapeStyle.swift
//

import UIKit

public extension LineShape {
    struct LineShapeStyle: HasFillStyle, HasStrokeStyle, HasLineStyle {
        public let fillColor: UIColor
        public let lineWidth: CGFloat
        public let strokeColor: UIColor
        public let strokeWidth: CGFloat
        public let lineCap: CGLineCap
        public let lineJoin: CGLineJoin

        public init(
            fillColor: UIColor,
            strokeColor: UIColor,
            strokeWidth: CGFloat,
            lineWidth: CGFloat,
            lineCap: CGLineCap,
            lineJoin: CGLineJoin
        ) {
            self.fillColor = fillColor
            self.lineWidth = lineWidth
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
            self.lineCap = lineCap
            self.lineJoin = lineJoin
        }
    }
}

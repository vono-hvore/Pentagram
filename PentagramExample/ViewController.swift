//
//  ViewController.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 01.06.2025.
//

import Foundation
import UIKit
import Pentagram

class Drawing: UIView {
    var points: [CGPoint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = true
        backgroundColor = .clear
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)
        )
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        if let firstPoint = points.first, let lastPoint = points.last {
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(2.0)
            context.move(to: firstPoint)
            context.addLine(to: lastPoint)
            context.strokePath()

            let firstDot = CGRect(
                x: firstPoint.x - 5, y: firstPoint.y - 5,
                width: 10, height: 10
            )
            let lastDot = CGRect(
                x: lastPoint.x - 5, y: lastPoint.y - 5,
                width: 10, height: 10
            )
            context.setFillColor(UIColor.red.cgColor)
            context.addRect(firstDot)
            context.addRect(lastDot)
            context.fillPath()
        }
    }

    @objc private func didTap(sender: UIGestureRecognizer) {
        let point = sender.location(in: self)
        if points.count >= 2 {
            points.removeAll()
        }
        points.append(point)
        setNeedsDisplay()
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDrawingView()
    }

    private func setupDrawingView() {
        view.addSubview(DrawingView(frame: view.frame))
    }
}

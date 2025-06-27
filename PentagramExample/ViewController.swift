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
    var drawingView: DrawingView!
    let toolBar: UIToolbar = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDrawingView()
        setupToolBar()
    }
    
    private func setupDrawingView() {
        let dotRadius = CGFloat(7)
        let shapeFactory = DotsShapeFactory(pointsCount: 2) { points in
            LineDotsImageShape(
                points[0],
                points[1],
                dotRadius: dotRadius,
                image: "arrow.right.square"
            )
        } draft: { point in
            CircleShape(.init(
                centroid: .init(x: point.x, y: point.y),
                width: dotRadius * 2,
                hedith: dotRadius * 2
            ))
        }
        drawingView = .init(shapePointsFactories: [.line: shapeFactory], frame: view.bounds)
        view.addSubview(drawingView)
    }
    
    private func setupToolBar() {
        view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        toolBar.items = [
            .init(
                image: .init(systemName: "line.diagonal"),
                style: .plain,
                target: self,
                action: #selector(lineTool)
            ),
            .init(
                image: .init(systemName: "hand.point.up.left.fill"),
                style: .plain,
                target: self,
                action: #selector(selectTool)
            )
        ]
    }
    
    @objc private func lineTool() {
        drawingView.select(tool: .line)
    }
    
    @objc private func selectTool() {
        drawingView.select(tool: .select)
    }
}

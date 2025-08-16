//
//  ViewController.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 01.06.2025.
//

import Foundation
import Pentagram
import UIKit

private enum ShapeType {
    case lineDots
}

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
    private var drawingView: GeometricalDrawingView!
    private var artCoordinator: ArtCoordinator<ShapeType>!
    let toolBar: UIToolbar = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDrawingView()
        setupToolBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        drawingView.frame = view.bounds
    }

    private func setupDrawingView() {
        let dotRadius = CGFloat(7)
        let shapeFactory = PointShapeFactory { points in
            if points.count == 2 {
                return .final(shape: LineDotsShape(
                    points[0],
                    points[1],
                    dotRadius: dotRadius
                ))
            } else {
                let point = points.last ?? .zero
                return .draft(shape: CircleShape(.init(
                    centroid: .init(x: point.x, y: point.y),
                    width: dotRadius * 2,
                    height: dotRadius * 2
                )))
            }
        }
        artCoordinator = .init(factories: [
            ShapeType.lineDots: shapeFactory,
        ])
        drawingView = .init(artCoordinator: artCoordinator)
        view.addSubview(drawingView)
    }

    private func setupToolBar() {
        view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        let items: [UIBarButtonItem] = [
            .flexibleSpace(),
            // Selection Tool
            .init(
                image: .init(systemName: "hand.point.up.left.fill"),
                style: .plain,
                target: self,
                action: #selector(selectTool)
            ),
            // Selection Tool
            .init(
                image: .init(systemName: "lasso"),
                style: .plain,
                target: self,
                action: #selector(selectTool)
            ),
            .init(
                image: .init(systemName: "pencil"),
                style: .plain,
                target: self,
                action: #selector(selectTool)
            ),
            // Shapes Menu
            .init(
                image: .init(systemName: "triangle"),
                menu: createShapesMenu()
            ),
            // Arrows Menu
            .init(
                image: .init(systemName: "arrow.up.forward"),
                menu: createArrowsMenu()
            ),
            // Curves Menu
            .init(
                image: .init(systemName: "point.bottomleft.forward.to.point.topright.scurvepath"),
                menu: createCurvesMenu()
            ),
            // Mask Menu
            .init(
                image: .init(systemName: "square.2.layers.3d.bottom.filled"),
                menu: createMaskMenu()
            ),
            // Color Picker
            .init(
                image: .init(systemName: "paintbrush.fill"),
                style: .plain,
                target: self,
                action: #selector(showColorPicker)
            ),
            // Clear Tool
            .init(
                image: .init(systemName: "delete.left.fill"),
                style: .plain,
                target: self,
                action: #selector(clearTool)
            ),
            .flexibleSpace(),
        ]

        toolBar.setItems(items, animated: false)
    }

    @objc private func selectTool() {
        artCoordinator.select(tool: .move)
    }

    @objc private func clearTool() {
        artCoordinator.eraseAll()
        drawingView.setNeedsDisplay()
    }

    @objc private func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = .red // Default color
        colorPicker.supportsAlpha = true
        present(colorPicker, animated: true)
    }

    // MARK: - Menu Creation

    private func createShapesMenu() -> UIMenu {
        let circleAction = UIAction(title: "Circle", image: UIImage(systemName: "circle")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        let rectangleAction = UIAction(title: "Rectangle", image: UIImage(systemName: "rectangle")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        let triangleAction = UIAction(title: "Triangle", image: UIImage(systemName: "triangle")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        return UIMenu(title: "Shapes", children: [circleAction, rectangleAction, triangleAction])
    }

    private func createArrowsMenu() -> UIMenu {
        let simpleArrowAction = UIAction(title: "Simple Arrow", image: UIImage(systemName: "arrow.up.forward")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        let curvedArrowAction = UIAction(title: "Curved Arrow", image: UIImage(systemName: "arrow.turn.up.right")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        return UIMenu(title: "Arrows", children: [simpleArrowAction, curvedArrowAction])
    }

    private func createCurvesMenu() -> UIMenu {
        let bezierAction = UIAction(title: "Bezier Curve", image: UIImage(systemName: "point.bottomleft.forward.to.point.topright.scurvepath")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        let lineAction = UIAction(title: "Polyline", image: UIImage(systemName: "point.3.connected.trianglepath.dotted")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        return UIMenu(title: "Complex", children: [bezierAction, lineAction])
    }

    private func createMaskMenu() -> UIMenu {
        let layersAction = UIAction(title: "Add", image: UIImage(systemName: "square.2.layers.3d.fill")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        let bottomLayerAction = UIAction(title: "Subtract", image: UIImage(systemName: "square.2.layers.3d.bottom.filled")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        return UIMenu(title: "Mask", children: [layersAction, bottomLayerAction])
    }
}

// MARK: - UIColorPickerViewControllerDelegate

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        // Here you can update the current drawing color
        // For example, you might want to store it in a property and use it when creating shapes
        print("Selected color: \(selectedColor)")
    }

    func colorPickerViewControllerDidFinish(_: UIColorPickerViewController) {
        dismiss(animated: true)
    }
}

//
//  ViewController.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 01.06.2025.
//

import Foundation
import PentagramFramework
import UIKit

private enum ShapeType {
    case lineDots
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
                return .final(
                    shape: LineDotsShape(
                        points[0],
                        points[1],
                        dotRadius: dotRadius
                    )
                )
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
        toolBar.setItems(barButtonItems, animated: false)
    }

    private var barButtonItems: [UIBarButtonItem] {
        [
            .flexibleSpace(),
            .init(
                image: .init(systemName: "hand.point.up.left.fill"),
                style: .plain,
                target: self,
                action: #selector(selectTool)
            ),
            .init(
                image: .init(systemName: "lasso"),
                style: .plain,
                target: self,
                action: #selector(selectTool)
            ),
            .init(
                image: .init(systemName: "rectangle"),
                style: .plain,
                target: self,
                action: #selector(selectTool)
            ),
            .init(
                image: .init(systemName: "point.bottomleft.forward.to.point.topright.scurvepath"),
                style: .plain,
                target: self,
                action: #selector(selectBezierCurve)
            ),
            .init(
                image: .init(systemName: "square.2.layers.3d.bottom.filled"),
                menu: createMaskMenu()
            ),
            .init(
                image: .init(systemName: "circle.fill")?.withTintColor(.red),
                style: .plain,
                target: self,
                action: #selector(showColorPicker)
            )
            .set(\.tintColor, value: .red),
            .init(
                image: .init(systemName: "delete.left.fill"),
                style: .plain,
                target: self,
                action: #selector(clearTool)
            ),
            .flexibleSpace(),
        ]
    }

    @objc private func selectTool() {
        artCoordinator.select(tool: .move)
    }

    @objc private func selectBezierCurve() {
        artCoordinator.select(tool: .draw(.lineDots))
    }

    @objc private func clearTool() {
        artCoordinator.eraseAll()
        drawingView.setNeedsDisplay()
    }

    @objc private func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = .red
        colorPicker.supportsAlpha = true
        present(colorPicker, animated: true)
    }

    // MARK: - Menu Creation

    private func createMaskMenu() -> UIMenu {
        let layersAction = UIAction(title: "Add", image: UIImage(systemName: "square.2.layers.3d.fill")) { _ in
            self.artCoordinator.select(tool: .draw(.lineDots))
        }

        let bottomLayerAction = UIAction(
            title: "Subtract",
            image: UIImage(systemName: "square.2.layers.3d.bottom.filled")
        ) { _ in
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

extension UIBarButtonItem {
    func set<T>(_ keyPath: ReferenceWritableKeyPath<UIBarButtonItem, T>, value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}

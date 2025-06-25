//
//  DrawingView.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import UIKit

@MainActor
public class DrawingView: UIView {
    private let contentView: UIView = .init()
    private let selectionView: UIView = RectangleSelectionView()
    private let interactiveView: UIView = .init()
    private var artCoordinator: ArtCoordinator = ArtCoordinator()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = true
        backgroundColor = .clear
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(onTap)
        )
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(onPan)
        )
        pan.maximumNumberOfTouches = 1
        let rotation = UIRotationGestureRecognizer(
            target: self,
            action: #selector(onRotate)
        )
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        addGestureRecognizer(pan)
        addGestureRecognizer(rotation)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGestureObserver(_ observer: ArtCoordinator) {
    }
    
    func removeGestureObserver(_ observer: ArtCoordinator) {
    }
    
    public override func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        artCoordinator.draw(in: context)
    }
    
    public func select(tool newTool: Tool) {
        artCoordinator.select(tool: newTool)
    }
}

private extension DrawingView {
    private func setupViews() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        clipsToBounds = true
        addSubview(contentView)
        addSubview(selectionView)
        addSubview(interactiveView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        interactiveView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @objc
    private func onTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        let state = sender.state
        Task { @MainActor [state, point] in
            await handleTap(state, point: point)
            setNeedsDisplay()
        }
    }
    
    @objc
    private func onPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        let state = sender.state
        Task { @MainActor [state, point] in
            await handleTap(state, point: point)
            setNeedsDisplay()
        }
    }
    
    @objc
    private func onRotate(_ sender: UIRotationGestureRecognizer) {
        let point = sender.location(in: self)
        let rotation = sender.rotation
        let state = sender.state
        Task { @MainActor [state, rotation] in
            await handleRotation(state, point: point, rotation: rotation)
            setNeedsDisplay()
        }
    }
    
    func handleTap(_ state: UIGestureRecognizer.State, point: CGPoint) async {
        switch state {
        case .began, .possible:
            print("begin: \(point)")
            await artCoordinator.receiveStartState(at: point)
        case .changed:
            print("changed: \(point)")
            await artCoordinator.receiveMovedState(to: point, dt: .zero)
        case .ended:
            print("ended: \(point)")
            await artCoordinator.receiveEndState(at: point)
        case .failed, .cancelled:
            print("failed: \(point)")
            await artCoordinator.receiveCancelledState()
        default: break
        }
    }
    
    func handleRotation(_ state: UIGestureRecognizer.State, point: CGPoint, rotation: CGFloat) async {
        switch state {
        case .began:
            print("begin: \(point)")
            await artCoordinator.receiveRotationStart(at: point)
        case .changed:
            print("changed: \(point)")
            await artCoordinator.receiveRotation(radians: rotation)
        case .ended:
            print("ended: \(point)")
            await artCoordinator.receiveEndState(at: point)
        case .failed, .cancelled:
            print("failed: \(point)")
            await artCoordinator.receiveCancelledState()
        default: break
        }
    }
}

//
//  GeometricalDrawingView.swift
//

import UIKit

public class GeometricalDrawingView: UIView {
    private let artCoordinator: ArtCoordinatorProtocol

    public init(artCoordinator: ArtCoordinatorProtocol) {
        self.artCoordinator = artCoordinator

        super.init(frame: .zero)

        setupViews()
        setupGestures()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        artCoordinator.draw(in: context)
    }
}

private extension GeometricalDrawingView {
    private func setupViews() {
        isOpaque = true
        backgroundColor = .clear
        isUserInteractionEnabled = true
        clipsToBounds = true
    }

    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        let pan = NoDelayPanGestureRecognizer(target: self, action: #selector(onPan))
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(onRotate))
        pan.maximumNumberOfTouches = 1

        addGestureRecognizer(tap)
        addGestureRecognizer(pan)
        addGestureRecognizer(rotation)
    }

    @objc private func onTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        let state = sender.state
        handleTap(state, point: point)
        setNeedsDisplay()
    }

    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        let state = sender.state
        handleTap(state, point: point)
        setNeedsDisplay()
    }

    @objc private func onRotate(_ sender: UIRotationGestureRecognizer) {
        let point = sender.location(in: self)
        let rotation = sender.rotation
        let state = sender.state
        handleRotation(state, point: point, rotation: rotation)
        setNeedsDisplay()
    }

    func handleTap(_ state: UIGestureRecognizer.State, point: CGPoint) {
        switch state {
        case .began, .possible:
            artCoordinator.receiveStartState(at: point)
        case .changed:
            artCoordinator.receiveMovedState(to: point, dt: .zero)
        case .ended:
            artCoordinator.receiveEndState(at: point)
        case .failed, .cancelled:
            artCoordinator.receiveCancelledState()
        default: break
        }
    }

    func handleRotation(_ state: UIGestureRecognizer.State, point: CGPoint, rotation: CGFloat) {
        switch state {
        case .began:
            artCoordinator.receiveRotationStart(at: point)
        case .changed:
            artCoordinator.receiveRotation(radians: rotation)
        case .ended:
            artCoordinator.receiveEndState(at: point)
        case .failed, .cancelled:
            artCoordinator.receiveCancelledState()
        default: break
        }
    }
}

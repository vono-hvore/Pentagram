//
//  DrawingView.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import UIKit

enum DrawingObjectType: Hashable {
    case dot,
         line,
         triangle,
         rect,
         pentagon,
         polygon
}

protocol DrawingObject {
    var uuid: UUID { get }
    var type: DrawingObjectType { get }
}

public class DrawingView: UIView {
    private let contentView: UIView = .init()
    private let selectionView: UIView = RectangleSelectionView()
    private let interactiveView: UIView = .init()
    private var artCoordinator: ArtCoordinator = ArtCoordinator()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = true
        backgroundColor = .clear
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)
        )
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        setupViews()
        addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGestureObserver(_ observer: ArtCoordinator) {
    }
    
    func removeGestureObserver(_ observer: ArtCoordinator) {
    }
    
    @MainActor
    public override func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        artCoordinator.draw(in: context)
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
    private func didTap(_ sender: UIGestureRecognizer) {
        let point = sender.location(in: self)
//        let observers = gestureObservers
//            .lazy
//            .compactMap { $0 as? GestureObservable }
//        
        switch sender.state {
        case .began:
            break
//            observers.forEach { $0.receiveStartState(at: point) }
        case .changed:
            break
//            observers.forEach { $0.receiveMovedState(to: point, dt: TimeInterval.zero) }
        case .ended:
            Task {
                print(point)
                await artCoordinator.receiveEndState(at: point)
                setNeedsDisplay()
            }
//            observers.forEach { $0.receiveEndState(at: point) }
        case .failed, .cancelled:
            break
//            observers.forEach { $0.receiveCancelledState() }
        default: break
        }
    }
}

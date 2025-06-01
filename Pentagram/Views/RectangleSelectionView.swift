//
//  RectangleSelectionView.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 04.06.2025.
//

import UIKit

// TODO: try to make it as shape with render context instead view
class RectangleSelectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // TODO: Create SelectionStyle
        let selectionLayer = CAShapeLayer()
        selectionLayer.strokeColor = UIColor.systemGray6.cgColor
        selectionLayer.lineWidth = 1
        selectionLayer.lineDashPattern = [2, 2]
        selectionLayer.frame = bounds
        selectionLayer.path = UIBezierPath(rect: selectionLayer.frame).cgPath
        
        layer.addSublayer(selectionLayer)
        layer.shadowColor = UIColor.yellow.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shadowOpacity = 1
        
        isHidden = true
    }
}

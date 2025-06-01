//
//  Shape.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 20.06.2025.
//

protocol Shape: Render, Identifiable {
    associatedtype ShapeStyle: Style
    
    var style: ShapeStyle { get }
}

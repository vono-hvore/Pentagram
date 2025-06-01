//
//  Render.swift
//  Pentagram
//
//  Created by Rodion Hladchenko on 19.06.2025.
//

import UIKit

protocol Render: Sendable {
    func render(in context: CGContext)
}


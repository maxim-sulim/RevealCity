//
//  Line.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//
import SwiftUI

struct Line: Shape {
    
    var axis: Axis
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        if axis == .vertical {
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        } else {
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
        return path
    }
}

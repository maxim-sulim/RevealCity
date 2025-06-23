//
//  ExploredArea.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import Foundation
import CoreLocation

struct ExploredArea: Codable, Equatable, Identifiable {
    var id = UUID()
    let centerPoint: LocationPoint
    let radius: Double
    let exploredAt: Date
    
    init(centerPoint: LocationPoint, radius: Double = 50.0) {
        self.centerPoint = centerPoint
        self.radius = radius
        self.exploredAt = Date()
    }
    
    func contains(_ point: LocationPoint) -> Bool {
        centerPoint.distance(to: point) <= radius
    }
    
    func overlaps(with other: ExploredArea) -> Bool {
        let distance = centerPoint.distance(to: other.centerPoint)
        return distance <= (radius + other.radius)
    }
}

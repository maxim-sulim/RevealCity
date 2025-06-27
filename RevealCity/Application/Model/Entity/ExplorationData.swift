//
//  ExplorationData.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import Foundation

struct ExplorationData: Codable, Equatable {
    var exploredAreas: [ExploredArea]
    var totalDistance: Double
    var explorationPercentage: Double
    var lastUpdated: Date
    
    mutating func addExploredArea(_ area: ExploredArea) {
        let overlappingAreas = exploredAreas.filter { $0.overlaps(with: area) }
        
        if overlappingAreas.isEmpty {
            exploredAreas.append(area)
            lastUpdated = Date()
        }
    }
}

extension ExplorationData {
    init() {
        self.exploredAreas = []
        self.totalDistance = 0
        self.explorationPercentage = 0
        self.lastUpdated = .now
    }
}

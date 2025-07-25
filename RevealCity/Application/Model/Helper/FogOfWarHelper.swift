//
//  FogOfWarHelper.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import Foundation
import CoreLocation

typealias Coordinate = (x: Double, y: Double)

enum FogState {
    case unseen
    case seen
    case visible
}

struct GridPoint: Hashable {
    let x: Int
    let y: Int
}

struct Cell: Identifiable, Hashable {
    let id = UUID()
    let point: GridPoint
    var fog: FogState = .unseen
}

final class FogOfWarUpdater {
    
    private var coordinate: Coordinate
    
    var xCount: Int
    var yCount: Int
    var cells: [[Cell]]
    
    init(xCount: Int = Constants.Size.map.gridWidth,
         yCount: Int = Constants.Size.map.gridHeight,
         coordinate: (x: Double, y: Double) = (x: Double(Constants.Size.map.center.x),
                                               y: Double(Constants.Size.map.center.y))) {
        self.coordinate = coordinate
        self.xCount = xCount
        self.yCount = yCount
        cells = (0..<yCount).map { y in
            (0..<xCount).map { x in
                Cell(point: .init(x: x, y: y))
            }
        }
    }
    
    func updateFog(from position: GridPoint, radius: Int) {
        for y in 0..<yCount {
            for x in 0..<xCount {
                let dx = x - position.x
                let dy = y - position.y
                let distance = sqrt(Double(dx * dx + dy * dy))
                
                if distance <= Double(radius) {
                    cells[y][x].fog = .visible
                } else if cells[y][x].fog == .visible {
                    cells[y][x].fog = .seen
                }
            }
        }
    }
    
    func fillingCoveredGridPoints(
        exploredAreas: [ExploredArea],
        mapTopLeft: CLLocationCoordinate2D,
        mapBottomRight: CLLocationCoordinate2D,
        gridSizeX: Int = 12,
        gridSizeY: Int = 14
    ) {
        var coveredPoints = Set<(GridPoint)>()

        let cellWidth = (mapBottomRight.longitude - mapTopLeft.longitude) / Double(gridSizeX)
        let cellHeight = (mapTopLeft.latitude - mapBottomRight.latitude) / Double(gridSizeY)
        
        for area in exploredAreas {
            let center = area.centerPoint.coordinate

            for x in 0..<gridSizeX {
                for y in 0..<gridSizeY {
                    let cellCenterLat = mapTopLeft.latitude - (Double(y) + 0.5) * cellHeight
                    let cellCenterLon = mapTopLeft.longitude + (Double(x) + 0.5) * cellWidth
                    
                    let cellLocation = CLLocation(latitude: cellCenterLat, longitude: cellCenterLon)
                    let areaLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
                    let distance = areaLocation.distance(from: cellLocation)

                    if distance <= area.radius {
                        coveredPoints.insert(.init(x: x, y: y))
                    }
                }
            }
        }

        coveredPoints.forEach { point in
            updateFog(from: point, radius: 2)
        }
    }
}

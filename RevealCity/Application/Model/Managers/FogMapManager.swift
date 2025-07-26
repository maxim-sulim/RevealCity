//
//  FogOfWarHelper.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import Foundation
import CoreLocation

typealias Coordinate = (x: Double, y: Double)

protocol FogMapManager {
    var xCount: Int { get }
    var yCount: Int { get }
    var cells: [[Cell]] { get }
    
    func updateFog(from position: GridPoint, radius: Int)
    
    func fillingCoveredGridPoints(
        exploredAreas: [ExploredArea],
        mapTopLeft: CLLocationCoordinate2D,
        mapBottomRight: CLLocationCoordinate2D,
    )
}

final class FogMapManagerImpl: FogMapManager {
    
    private var coordinate: Coordinate
    
    var xCount: Int
    var yCount: Int
    var cells: [[Cell]]
    
    init(xCount: Int = Constants.SizeMap.cellXCount,
         yCount: Int = Constants.SizeMap.cellYCount,
         coordinate: (x: Double, y: Double) = (x: Double(Constants.SizeMap.center.x),
                                               y: Double(Constants.SizeMap.center.y))) {
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
        mapBottomRight: CLLocationCoordinate2D
    ) {
        let gridSize = Constants.SizeMap.cellSize
        var coveredPoints = Set<(GridPoint)>()

        let cellWidth = (mapBottomRight.longitude - mapTopLeft.longitude) / Double(gridSize)
        let cellHeight = (mapTopLeft.latitude - mapBottomRight.latitude) / Double(gridSize)
        
        for area in exploredAreas {
            let center = area.centerPoint.coordinate

            for x in 0..<gridSize {
                for y in 0..<gridSize {
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

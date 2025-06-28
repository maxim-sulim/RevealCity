//
//  FogOfWarHelper.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import Foundation

enum FogState {
    case unseen
    case seen
    case visible
}

struct Tile: Identifiable, Hashable {
    let id = UUID()
    let x: Int
    let y: Int
    var fog: FogState = .unseen
}


final class FogOfWarUpdater {
    
    var xCount: Int
    var yCount: Int
    
    private(set) var tiles: [[Tile]]

    init(xCount: Int, yCount: Int) {
        self.xCount = xCount
        self.yCount = yCount
        self.tiles = (0..<yCount).map { y in
            (0..<xCount).map { x in
                Tile(x: x, y: y)
            }
        }
    }
    
    func setGrid(xCount: Int, yCount: Int) {
        self.xCount = xCount
        self.yCount = yCount
    }

    func updateFog(from position: (x: Int, y: Int), radius: Int) {
        for y in 0..<yCount {
            for x in 0..<xCount {
                let dx = x - position.x
                let dy = y - position.y
                let distance = sqrt(Double(dx * dx + dy * dy))

                if distance <= Double(radius) {
                    tiles[y][x].fog = .visible
                } else if tiles[y][x].fog == .visible {
                    tiles[y][x].fog = .seen
                }
            }
        }
    }
}

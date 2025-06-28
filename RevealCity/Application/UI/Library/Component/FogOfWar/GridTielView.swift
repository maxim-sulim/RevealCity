//
//  GridTielView.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import SwiftUI

struct GridTilesView: View {
    
    var tiles: [[Tile]]
    var playerPosition: (x: Int, y: Int)

    var body: some View {
        VStack(spacing: 0) {
            ForEach(tiles, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row) { tile in
                        TileView(tile: tile, isPlayerHere: isPlayer(tile))
                    }
                }
            }
        }
    }

    private func isPlayer(_ tile: Tile) -> Bool {
        tile.x == playerPosition.x && tile.y == playerPosition.y
    }
}

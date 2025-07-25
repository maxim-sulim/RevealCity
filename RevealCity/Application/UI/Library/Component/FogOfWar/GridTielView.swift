//
//  GridTielView.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import SwiftUI

struct GridTilesView: View {
    
    var tiles: [[Cell]]
    var playerPosition: GridPoint

    var body: some View {
        VStack(spacing: .zero) {
            ForEach(tiles, id: \.self) { row in
                HStack(spacing: .zero) {
                    ForEach(row) { tile in
                        TileView(tile: tile, isPlayerHere: isPlayer(tile))
                    }
                }
            }
        }
    }

    private func isPlayer(_ tile: Cell) -> Bool {
        tile.point.x == playerPosition.x && tile.point.y == playerPosition.y
    }
}

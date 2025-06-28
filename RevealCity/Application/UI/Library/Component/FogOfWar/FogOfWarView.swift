//
//  FogOfWarView.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import Foundation
import SwiftUI

@MainActor
protocol FogOfWarModel: ObservableObject {
    var tiles: [[Tile]] { get }
    var playerPosition: (x: Int, y: Int) { get }
    
    func movePlayer(dx: Int, dy: Int)
}

struct FogOfWarView<Model: FogOfWarModel>: View {
    
    @ObservedObject var model: Model

    var body: some View {
        GridTilesView(tiles: model.tiles,
                playerPosition: model.playerPosition)
            .overlay(alignment: .bottom) {
                HStack {
                    Button("◀️") { model.movePlayer(dx: -1, dy: 0) }
                    VStack {
                        Button("🔼") { model.movePlayer(dx: 0, dy: -1) }
                        Button("🔽") { model.movePlayer(dx: 0, dy: 1) }
                    }
                    Button("▶️") { model.movePlayer(dx: 1, dy: 0) }
                }
                .padding(.bottom)
            }
    }
}


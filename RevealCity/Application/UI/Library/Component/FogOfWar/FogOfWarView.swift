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
    var cells: [[Cell]] { get }
    var playerPosition: GridPoint { get }
    
    func movePlayer(dx: Int, dy: Int)
}

struct FogOfWarView<Model: FogOfWarModel>: View {
    
    @ObservedObject var model: Model

    var body: some View {
        GridTilesView(tiles: model.cells,
                playerPosition: model.playerPosition)
    }
}


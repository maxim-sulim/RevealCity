import Foundation
import SwiftUI

@MainActor
protocol FogOfWarModel: ObservableObject {
    var cells: [[Cell]] { get }
    var playerPosition: GridPoint { get }
}

struct FogOfWarView<Model: FogOfWarModel>: View {
    
    @ObservedObject var model: Model
    
    var body: some View {
        GridCellsView(cells: model.cells,
                      playerPosition: model.playerPosition)
    }
}


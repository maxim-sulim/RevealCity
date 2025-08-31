import SwiftUI

struct GridCellsView: View {
    
    var cells: [[Cell]]
    var playerPosition: GridPoint

    var body: some View {
        LazyVStack(spacing: .zero) {
            ForEach(cells, id: \.self) { row in
                LazyHStack(spacing: .zero) {
                    ForEach(row) { cell in
                        CellFogView(cell: cell, isPlayerHere: isPlayer(cell))
                    }
                }
            }
        }
    }

    private func isPlayer(_ cell: Cell) -> Bool {
        cell.point.x == playerPosition.x && cell.point.y == playerPosition.y
    }
}

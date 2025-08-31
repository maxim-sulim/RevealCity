import SwiftUI

struct CellFogView: View {
    let cell: Cell
    let isPlayerHere: Bool
    let cellSize: CGFloat = CGFloat(Constants.SizeMap.cellSize)

    @State private var fogAlpha: Double = 1.0

    var body: some View {
        ZStack {
            if isPlayerHere {
                Circle().fill(Color.blue).frame(width: 6, height: 6)
            }

            Rectangle()
                .fill(Color.black)
                .opacity(fogAlpha)
        }
        .frame(width: cellSize, height: cellSize)
        .onAppear {
            updateFogAlpha()
        }
        .onChange(of: cell.fog) { _ in
            updateFogAlpha()
        }
    }

    private func updateFogAlpha() {
        switch cell.fog {
        case .unseen:
            fogAlpha = 0.6
        case .seen:
            fogAlpha = 0.3
        case .visible:
            fogAlpha = 0.0
        }
    }
}

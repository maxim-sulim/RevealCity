//
//  TileView.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import SwiftUI

struct TileView: View {
    let tile: Cell
    let isPlayerHere: Bool

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
        .frame(width: 12, height: 12)
        .onAppear {
            updateFogAlpha()
        }
        .onChange(of: tile.fog) { _ in
            updateFogAlpha()
        }
    }

    private func updateFogAlpha() {
        switch tile.fog {
        case .unseen:
            fogAlpha = 0.6
        case .seen:
            fogAlpha = 0.3
        case .visible:
            fogAlpha = 0.0
        }
    }
}

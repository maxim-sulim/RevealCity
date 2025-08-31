import Foundation

struct GridPoint: Hashable {
    let x: Int
    let y: Int
}

struct Cell: Identifiable, Hashable {
    let id = UUID()
    let point: GridPoint
    var fog: FogState = .unseen
}

extension GridPoint {
    static let center = Constants.SizeMap.center
}

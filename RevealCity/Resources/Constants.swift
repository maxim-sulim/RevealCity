import Foundation
import UIKit

enum Constants {
    
    enum SizeMap {
        static let cellSize = 12
        
        static let width: CGFloat = CGFloat(Int(cellXCount) * cellSize)
        static let height: CGFloat = CGFloat(Int(cellYCount) * cellSize)
        
        static let cellXCount: Int = Int((UIScreen.main.bounds.width - 20) / CGFloat(cellSize))
        static let cellYCount: Int = Int((UIScreen.main.bounds.height - 150) / CGFloat(cellSize))
        
        static let center: GridPoint = .init(x: cellXCount / 2, y: cellYCount / 2)
    }
}

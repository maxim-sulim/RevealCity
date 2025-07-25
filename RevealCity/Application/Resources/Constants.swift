//
//  Constants.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//
import Foundation
import UIKit

enum Constants {
    
    enum Size {
        case map
        
        var width: CGFloat {
            switch self {
            case .map: CGFloat(self.gridWidth) * 12
            }
        }
        
        var height: CGFloat {
            switch self {
            case .map: CGFloat(self.gridHeight) * 14
            }
        }
        
        var gridWidth: Int {
            switch self {
            case .map: Int(UIScreen.main.bounds.width / 12)
            }
        }
        
        var gridHeight: Int {
            switch self {
            case .map: Int(UIScreen.main.bounds.height / 14)
            }
        }
        
        var center: GridPoint {
            switch self {
            case .map: .init(x: gridWidth / 2, y: gridHeight / 2)
            }
        }
    }
}

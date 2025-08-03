//
//  FogManagerMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 03.08.2025.
//

import Foundation
import Combine
import YandexMapsMobile

final class FogManagerMock: FogMapManager {
    func setPositionToCenter() {
        
    }
    
    var cellsPublisher: AnyPublisher<[[Cell]], Never> {
        $cells.eraseToAnyPublisher()
    }
    
    @Published var cells: [[Cell]] = []
    
    var playerPositionPublisher: AnyPublisher<GridPoint, Never> {
        $position.eraseToAnyPublisher()
    }
    
    @Published var position: GridPoint = .init(x: 0, y: 0)
    
    func movePlayer(dx: Int, dy: Int) {
        
    }
    
    func start(subscribe: AnyPublisher<YMKMapView?, Never>) {
        
    }
}

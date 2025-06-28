//
//  MapManageMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//
import Combine
import MapKit

final class ExplorationMock: ExplorationObserver {
    
    var explorationDataPublished: AnyPublisher<ExplorationData, Never> { $explorationData.eraseToAnyPublisher() }
    
    @Published private var explorationData: ExplorationData = .init()
}

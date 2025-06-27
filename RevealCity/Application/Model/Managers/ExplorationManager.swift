//
//  MapManager.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import Combine
import CoreLocation
import MapKit

private struct CityBounds {
    let totalArea: Double = 50_000_000.0
}

protocol ExplorationManager {
    var explorationDataPublished: AnyPublisher<ExplorationData, Never> { get }
}

final class ExplorationManagerImpl: ExplorationManager {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let logger: LoggerManager
    private let locationService: LocationService
    private let keychainService: KeychainServiceImpl
    
    @Published private var currentLocation: LocationPoint?
    @Published private var explorationData = ExplorationData()
    
    private let explorationRadius: Double = 50.0
    private let cityBounds = CityBounds()
   
    var explorationDataPublished: AnyPublisher<ExplorationData, Never> {
        $explorationData.eraseToAnyPublisher()
    }
 
    init(locationService: LocationService,
         keychainService: KeychainServiceImpl,
         logger: LoggerManager) {
        self.locationService = locationService
        self.keychainService = keychainService
        self.logger = logger
        
        bind()
    }
    
    private func bind() {
        locationService.currentLocationPublisher
            .receive(on: RunLoop.main)
            .compactMap({ $0 })
            .sink { [weak self] location in
                guard let self else { return }
                
                handleLocationUpdate(location)
            }
            .store(in: &cancellables)
    }
    
    private func handleLocationUpdate(_ location: CLLocation) {
        let locationPoint = LocationPoint(
            coordinate: location.coordinate,
            accuracy: location.horizontalAccuracy
        )
        
        currentLocation = locationPoint
        
        if location.horizontalAccuracy < 50 {
            addExploredArea(at: locationPoint)
        }
    }
    
    private func addExploredArea(at location: LocationPoint) {
        let newArea = ExploredArea(centerPoint: location, radius: explorationRadius)
        
        let wasAlreadyExplored = explorationData.exploredAreas.contains { area in
            area.contains(location)
        }
        
        if !wasAlreadyExplored {
            explorationData.addExploredArea(newArea)
            updateExplorationPercentage()
            saveExplorationData()
        }
    }
    
    private func updateExplorationPercentage() {
        let totalCityArea = cityBounds.totalArea
        let exploredArea = calculateExploredArea()
        
        explorationData.explorationPercentage = min(100.0, (exploredArea / totalCityArea) * 100.0)
    }
    
    private func calculateExploredArea() -> Double {
        let circleArea = Double.pi * explorationRadius * explorationRadius
        return Double(explorationData.exploredAreas.count) * circleArea
    }
    
    private func saveExplorationData() {
        do {
            try keychainService.setObject(explorationData, forKey: Keys.Storage.exploration.rawValue)
            logger.log("Save exploration data")
        } catch let error {
            logger.log("Error: \(error.localizedDescription)")
        }
    }
}

//
//  MainViewModel.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import Foundation
import SwiftUI
import YandexMapsMobile
import CoreLocation
import Combine

@MainActor
protocol MainViewModel: ObservableObject, YandexMapModel, FogOfWarModel {
    var exploredPercent: Double { get }
    
    func dispatch(_ event: MainViewModelImpl.Event)
}

@MainActor
protocol MainCoordinatorDelegate {
    
}

@MainActor
final class MainViewModelImpl: MainViewModel {
    
    enum Event {
        case onAppear
        case currentLocationTapped
    }
    
    private let coordinator: MainCoordinatorDelegate
    private let locationService: LocationService
    private let explorationMaanger: ExplorationObserver
    
    private var fogManager: FogMapManager
    private var cancellables = Set<AnyCancellable>()
    
    private var currentLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    @Published var mapView = YMKMapView(frame: CGRect.zero)
    @Published var exploredPercent: Double = 0
    @Published var cells: [[Cell]] = []
    @Published var playerPosition: GridPoint = Constants.SizeMap.center
    
    init(coordinator: MainCoordinatorDelegate,
         locationService: LocationService,
         explorationMaanger: ExplorationObserver,
         fogManager: FogMapManager) {
        self.coordinator = coordinator
        self.locationService = locationService
        self.explorationMaanger = explorationMaanger
        self.fogManager = fogManager
        
        bind()
    }
    
    private func bind() {
        locationService.currentLocationPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let self, let location = location else { return }
                guard location != self.lastLocation else { return }
                locationUpdate(location: location)
            }
            .store(in: &cancellables)
        
        explorationMaanger.explorationDataPublished
            .receive(on: RunLoop.main)
            .map { $0.explorationPercentage }
            .assign(to: &$exploredPercent)
        
        $playerPosition
            .receive(on: RunLoop.main)
            .sink { [weak self] newPosition in
                self?.updateFog(from: newPosition)
            }
            .store(in: &cancellables)
    }
    
    private func locationUpdate(location: CLLocation) {
        if lastLocation == nil {
            lastLocation = location
        }
        self.currentLocation = location
        
        do {
            let newPosition = try calculateMovePlayerPosition()
            
            movePlayer(dx: newPosition.x, dy: newPosition.y)
            self.lastLocation = currentLocation
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateExploredArea() {
        let explorationData = explorationMaanger.getExploredData()
        guard let mapWindow = mapView?.mapWindow else { return }
        
        let screenMax = YMKScreenPoint(x: Float(mapWindow.width()), y: Float(mapWindow.height()))
        let screenMin = YMKScreenPoint(x: 0, y: 0)
        
        guard let mapBottomRight = mapWindow.screenToWorld(with: screenMax),
              let mapTopLeft = mapWindow.screenToWorld(with: screenMin) else { return }
        
        fogManager.fillingCoveredGridPoints(exploredAreas: explorationData.exploredAreas,
                                            mapTopLeft: .init(latitude: mapTopLeft.latitude,
                                                              longitude: mapTopLeft.longitude),
                                            mapBottomRight: .init(latitude: mapBottomRight.latitude,
                                                                  longitude: mapBottomRight.longitude))
        
    }
    
    private func setCenterMapLocation(target location: YMKPoint?, map: YMKMapView) {
        guard let location = location else { return }
        map.mapWindow.map.move(
            with: YMKCameraPosition(target: location, zoom: 16, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5)
        )
    }
    
    private func moveMapToCenter() {
        if let myLocation = currentLocation, let map = mapView {
            playerPosition = Constants.SizeMap.center
            setCenterMapLocation(target: YMKPoint(latitude: myLocation.coordinate.latitude,
                                                  longitude: myLocation.coordinate.longitude),
                                 map: map)
        }
    }
    
    private func onAppear() {
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                moveMapToCenter()
                updateExploredArea()
            }
        }
    }
    
    private func updateFog(from position: GridPoint) {
        fogManager.updateFog(from: position, radius: 2)
        cells = fogManager.cells
    }
    
    private func calculateMovePlayerPosition() throws -> GridPoint {
        guard let mapWindow = mapView?.mapWindow,
              let currentLocation = currentLocation,
              let lastLocation = lastLocation else {
            throw URLError(.unknown)
        }
        
        let screenMax = YMKScreenPoint(x: Float(mapWindow.width()), y: Float(mapWindow.height()))
        let screenMin = YMKScreenPoint(x: 0, y: 0)
        
        guard let worldMax = mapWindow.screenToWorld(with: screenMax),
              let worldMin = mapWindow.screenToWorld(with: screenMin) else {
            throw URLError(.unknown)
        }
        
        let worldDx = (worldMax.longitude - worldMin.longitude) / Double(Constants.SizeMap.cellSize)
        let worldDy = (worldMax.latitude - worldMin.latitude) / Double(Constants.SizeMap.cellSize)
        
        guard worldDx != 0 && worldDy != 0 else {
            throw URLError(.unknown)
        }
        
        let dx = Int((currentLocation.coordinate.longitude - lastLocation.coordinate.longitude) / worldDx)
        let dy = Int((currentLocation.coordinate.latitude - lastLocation.coordinate.latitude) / worldDy)
        
        return .init(x: dx, y: dy)
    }
}

//MARK: - output
extension MainViewModelImpl {
    
    func dispatch(_ event: Event) {
        switch event {
        case .onAppear:
            onAppear()
        case .currentLocationTapped:
            moveMapToCenter()
            updateExploredArea()
        }
    }
}

//MARK: delegate FogOfWarModel
extension MainViewModelImpl {
    
    func movePlayer(dx: Int, dy: Int) {
        let newX = max(0, min(fogManager.xCount - 1, playerPosition.x + dx))
        let newY = max(0, min(fogManager.yCount - 1, playerPosition.y + dy))
        playerPosition = .init(x: newX, y: newY)
    }
}

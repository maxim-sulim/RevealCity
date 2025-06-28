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
        case updateGrid(CGSize)
    }
    
    private let coordinator: MainCoordinatorDelegate
    private let locationService: LocationService
    private let explorationMaanger: ExplorationObserver

    private var fogUpdater: FogOfWarUpdater
    private var cancellables = Set<AnyCancellable>()
    
    @Published
    private var currnetLocation: CLLocation?
    
    @Published var mapView = YMKMapView(frame: CGRect.zero)
    @Published var exploredPercent: Double = 0
    @Published var tiles: [[Tile]] = []
    @Published var playerPosition: (x: Int, y: Int) = Constants.Size.map.center
    
    init(coordinator: MainCoordinatorDelegate,
         locationService: LocationService,
         explorationMaanger: ExplorationObserver) {
        self.coordinator = coordinator
        self.locationService = locationService
        self.explorationMaanger = explorationMaanger
        
        fogUpdater = .init(xCount: Constants.Size.map.gridWidth,
                           yCount: Constants.Size.map.gridHeight)
        
        bind()
    }
    
    private func bind() {
        locationService.currentLocationPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$currnetLocation)
        
        explorationMaanger.explorationDataPublished
            .receive(on: RunLoop.main)
            .map { $0.explorationPercentage }
            .assign(to: &$exploredPercent)
        
        $playerPosition
            .sink { [weak self] newPosition in
                self?.updateFog(from: newPosition)
            }
            .store(in: &cancellables)
    }
    
    private func setCenterMapLocation(target location: YMKPoint?, map: YMKMapView) {
        guard let location = location else { return }
        map.mapWindow.map.move(
            with: YMKCameraPosition(target: location, zoom: 16, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5)
        )
    }
    
    private func moveToUserLocation(){
        if let myLocation = currnetLocation, let map = mapView {
            setCenterMapLocation(target: YMKPoint(latitude: myLocation.coordinate.latitude,
                                               longitude: myLocation.coordinate.longitude),
                              map: map)
        }
    }
    
    private func moveToUserWithDelay() {
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                moveToUserLocation()
            }
        }
    }
    
    private func updateFog(from position: (x: Int, y: Int)) {
        fogUpdater.updateFog(from: position, radius: 2)
        tiles = fogUpdater.tiles
    }
    
    private func updateGrid(size: CGSize) {
        fogUpdater.setGrid(xCount: Int(size.width / 12),
                           yCount: Int(size.height / 14))
        updateFog(from: playerPosition)
    }
}

//MARK: - output
extension MainViewModelImpl {
    
    func dispatch(_ event: Event) {
        switch event {
        case .onAppear:
            moveToUserWithDelay()
        case .currentLocationTapped:
            moveToUserLocation()
        case .updateGrid(let size):
            updateGrid(size: size)
        }
    }
}

//MARK: delegate FogOfWarModel
extension MainViewModelImpl {
    
    func movePlayer(dx: Int, dy: Int) {
        let newX = max(0, min(fogUpdater.xCount - 1, playerPosition.x + dx))
        let newY = max(0, min(fogUpdater.yCount - 1, playerPosition.y + dy))
        playerPosition = (newX, newY)
    }
}

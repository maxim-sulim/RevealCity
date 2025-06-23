//
//  MainViewModel.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import Foundation
import SwiftUI
import MapKit

@MainActor
protocol MainViewModel: ObservableObject {
    
    var region: MKCoordinateRegion { get set }
    var currentPoint: LocationPoint? { get }
    var explorationData: ExplorationData { get }
    
    func dispatch(_ event: MainViewModelImpl.Event)
    
}

@MainActor
protocol MainCoordinatorDelegate {
    
}

@MainActor
final class MainViewModelImpl: MainViewModel {
    
    enum Event {
        case onAppear
        case onDisappear
        case currentLocationTapped
    }
    
    private let coordinator: MainCoordinatorDelegate
    private let locationService: LocationService
    private let mapManager: MapManager
    
    @Published var region: MKCoordinateRegion = .init()
    @Published var currentPoint: LocationPoint?
    @Published var explorationData: ExplorationData = .init()
    
    init(coordinator: MainCoordinatorDelegate,
         locationService: LocationService,
         mapManager: MapManager) {
        self.mapManager = mapManager
        self.coordinator = coordinator
        self.locationService = locationService
        
        bind()
    }
    
    private func bind() {
        mapManager.regionPublished
            .subscribe(on: RunLoop.main)
            .assign(to: &$region)
        
        mapManager.currentLocationPublished
            .subscribe(on: RunLoop.main)
            .assign(to: &$currentPoint)
        
        mapManager.explorationDataPublished
            .subscribe(on: RunLoop.main)
            .assign(to: &$explorationData)
    }
    
    private func startLocationMonitoring() {
        locationService.startLocationUpdates()
    }
    
    private func stopLocationMonitoring() {
        locationService.stopLocationUpdates()
    }
}

//MARK: - outpu
extension MainViewModelImpl {
    
    func dispatch(_ event: Event) {
        switch event {
        case .onAppear:
            startLocationMonitoring()
        case .onDisappear:
            stopLocationMonitoring()
        case .currentLocationTapped:
            mapManager.toMyselfLocation()
        }
    }
}


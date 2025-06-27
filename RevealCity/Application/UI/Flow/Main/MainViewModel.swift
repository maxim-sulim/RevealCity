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

@MainActor
protocol MainViewModel: ObservableObject, YandexMapModel {
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
    private let explorationMaanger: ExplorationManager
    
    @Published
    private var currnetLocation: CLLocation?
    
    @Published var mapView = YMKMapView(frame: CGRect.zero)
    @Published var exploredPercent: Double = 0
    
    init(coordinator: MainCoordinatorDelegate,
         locationService: LocationService,
         explorationMaanger: ExplorationManager) {
        self.coordinator = coordinator
        self.locationService = locationService
        self.explorationMaanger = explorationMaanger
        
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
    }
    
    private func setCenterMapLocation(target location: YMKPoint?, map: YMKMapView) {
        guard let location = location else { return }
        map.mapWindow.map.move(
            with: YMKCameraPosition(target: location, zoom: 18, azimuth: 0, tilt: 0),
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
}

//MARK: - output
extension MainViewModelImpl {
    
    func dispatch(_ event: Event) {
        switch event {
        case .onAppear:
            moveToUserWithDelay()
        case .currentLocationTapped:
            moveToUserLocation()
        }
    }
}


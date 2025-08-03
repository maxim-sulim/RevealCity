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
         explorationMaanger: ExplorationObserver,
         locationService: LocationService,
         fogManager: FogMapManager) {
        self.coordinator = coordinator
        self.explorationMaanger = explorationMaanger
        self.locationService = locationService
        self.fogManager = fogManager
        
        bind()
        fogManager.start(subscribe: $mapView.eraseToAnyPublisher())
    }
    
    private func bind() {
        fogManager.playerPositionPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$playerPosition)
        
        fogManager.cellsPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$cells)
        
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
    }
    
    private func locationUpdate(location: CLLocation) {
        if lastLocation == nil {
            lastLocation = location
        }
        self.lastLocation = currentLocation
        self.currentLocation = location
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
            }
        }
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
        }
    }
}


import Foundation
import CoreLocation
import YandexMapsMobile
import Combine

protocol FogMapManager {
    var cellsPublisher: AnyPublisher<[[Cell]], Never> { get }
    var playerPositionPublisher: AnyPublisher<GridPoint, Never> { get }
    
    func start(subscribe: AnyPublisher<YMKMapView?, Never>)
    func setPositionToCenter()
}

final class FogMapManagerImpl: FogMapManager {
    
    private let locationService: LocationService
    private let explorationMaanger: ExplorationObserver
    
    private var cancellables: Set<AnyCancellable> = []
    private let xCount: Int = Constants.SizeMap.cellXCount
    private let yCount: Int = Constants.SizeMap.cellYCount
    private var currentLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    @Published private var map: YMKMapView?
    @Published private var cells: [[Cell]] = []
    @Published private var playerPosition: GridPoint = .center
    
    var cellsPublisher: AnyPublisher<[[Cell]], Never> {
        $cells.eraseToAnyPublisher()
    }
    
    var playerPositionPublisher: AnyPublisher<GridPoint, Never> {
        $playerPosition.eraseToAnyPublisher()
    }
    
    init(locationService: LocationService,
         explorationMaanger: ExplorationObserver) {
        self.locationService = locationService
        self.explorationMaanger = explorationMaanger
        
        setup()
        bind()
    }
    
    private func bind() {
        locationService.currentLocationPublisher
            .sink { [weak self] location in
                guard let self, let location = location else { return }
                guard location != self.lastLocation else { return }
                locationUpdate(location: location)
            }
            .store(in: &cancellables)
        
        $playerPosition
            .sink { [weak self] newPosition in
                self?.updateFog(from: newPosition)
            }
            .store(in: &cancellables)
        
        $map
            .sink { map in
                guard let map = map else { return }
                print("UPDATE MAP")
            }
            .store(in: &cancellables)
    }
    
    private func setup() {
        cells = (0..<yCount).map { y in
            (0..<xCount).map { x in
                Cell(point: .init(x: x, y: y))
            }
        }
    }
    
    private func updateFog(from position: GridPoint) {
        updateFog(from: position, radius: 2)
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
    
    private func updateFog(from position: GridPoint, radius: Int) {
        for y in 0..<yCount {
            for x in 0..<xCount {
                let dx = x - position.x
                let dy = y - position.y
                let distance = sqrt(Double(dx * dx + dy * dy))
                if distance <= Double(radius) {
                    cells[y][x].fog = .visible
                } else if cells[y][x].fog == .visible {
                    cells[y][x].fog = .seen
                }
            }
        }
    }
    
    private func fillingCoveredGridPoints(
        exploredAreas: [ExploredArea],
        mapTopLeft: CLLocationCoordinate2D,
        mapBottomRight: CLLocationCoordinate2D
    ) {
        let gridSize = Constants.SizeMap.cellSize
        var coveredPoints = Set<(GridPoint)>()
        
        let cellWidth = (mapBottomRight.longitude - mapTopLeft.longitude) / Double(gridSize)
        let cellHeight = (mapTopLeft.latitude - mapBottomRight.latitude) / Double(gridSize)
        
        for area in exploredAreas {
            let center = area.centerPoint.coordinate
            
            for x in 0..<gridSize {
                for y in 0..<gridSize {
                    let cellCenterLat = mapTopLeft.latitude - (Double(y) + 0.5) * cellHeight
                    let cellCenterLon = mapTopLeft.longitude + (Double(x) + 0.5) * cellWidth
                    
                    let cellLocation = CLLocation(latitude: cellCenterLat, longitude: cellCenterLon)
                    let areaLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
                    let distance = areaLocation.distance(from: cellLocation)
                    
                    if distance <= area.radius {
                        coveredPoints.insert(.init(x: x, y: y))
                    }
                }
            }
        }
        
        coveredPoints.forEach { point in
            updateFog(from: point, radius: 2)
        }
    }
    
    private func updateExploredArea() {
        let explorationData = explorationMaanger.getExploredData()
        guard let mapWindow = map?.mapWindow else { return }
        
        let screenMax = YMKScreenPoint(x: Float(mapWindow.width()), y: Float(mapWindow.height()))
        let screenMin = YMKScreenPoint(x: 0, y: 0)
        
        guard let mapBottomRight = mapWindow.screenToWorld(with: screenMax),
              let mapTopLeft = mapWindow.screenToWorld(with: screenMin) else { return }
        
        fillingCoveredGridPoints(exploredAreas: explorationData.exploredAreas,
                                 mapTopLeft: .init(latitude: mapTopLeft.latitude,
                                                   longitude: mapTopLeft.longitude),
                                 mapBottomRight: .init(latitude: mapBottomRight.latitude,
                                                       longitude: mapBottomRight.longitude))
        
    }
    
    private func calculateMovePlayerPosition() throws -> GridPoint {
        guard let mapWindow = map?.mapWindow,
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
    
    private func movePlayer(dx: Int, dy: Int) {
        let newX = max(0, min(xCount - 1, playerPosition.x + dx))
        let newY = max(0, min(yCount - 1, playerPosition.y + dy))
        playerPosition = .init(x: newX, y: newY)
    }
}

//MARK: - output
extension FogMapManagerImpl {
    
    func start(subscribe: AnyPublisher<YMKMapView?, Never>)  {
        subscribe.assign(to: &$map)
    }
    
    func setPositionToCenter() {
        playerPosition = .center
    }
}

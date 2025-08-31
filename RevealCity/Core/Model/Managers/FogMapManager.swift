
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
        locationService.locationPublisher
            .replaceError(with: nil)
            .compactMap({ $0 })
            .sink { [weak self] location in
                guard let self else { return }
                guard let last = location.last,
                      last != self.lastLocation else { return }
                locationUpdate(location: last)
            }
            .store(in: &cancellables)
        
        $playerPosition
            .sink { [weak self] newPosition in
                self?.updateFog(from: newPosition)
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
        guard lastLocation != nil else {
            lastLocation = location
            return
        }
        
        currentLocation = location
        
        guard let mapWindow = map?.mapWindow,
              let oldLoc = lastLocation,
              let newLoc = currentLocation,
              let metersPerBlock = metersPerBlock(in: mapWindow),
              isLocationMovedEnough(from: oldLoc,
                                    to: newLoc,
                                    threshold: min(metersPerBlock.x, metersPerBlock.y)) else {
            return
        }
        
        guard let newPosition = calculateMovePlayerPosition() else {
            return
        }
        
        lastLocation = currentLocation
        movePlayer(dx: newPosition.x, dy: newPosition.y)
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
    
    
    private func updateExploredArea()  {
        guard let mapWindow = map?.mapWindow else { return }
        
        Task { @MainActor in
            let explorationData = explorationMaanger.getExploredData()
            
            await MainActor.run {
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
        }
    }
    
    private func calculateMovePlayerPosition() -> GridPoint?  {
        guard let mapWindow = map?.mapWindow,
              let newLocation = currentLocation,
              let oldLocation = lastLocation,
              let blockSize = metersPerBlock(in: mapWindow) else {
            return nil
        }
        
        let oldLoc = CLLocation(latitude: oldLocation.coordinate.latitude,
                                longitude: oldLocation.coordinate.longitude)
        let newLoc = CLLocation(latitude: newLocation.coordinate.latitude,
                                longitude: newLocation.coordinate.longitude)
        
        let dxMeters = CLLocation(
            latitude: oldLoc.coordinate.latitude,
            longitude: newLoc.coordinate.longitude
        ).distance(from: oldLoc)
        
        let dyMeters = CLLocation(
            latitude: newLoc.coordinate.latitude,
            longitude: oldLoc.coordinate.longitude
        ).distance(from: oldLoc)
        
        let dx = Int(dxMeters / blockSize.x)
        let dy = Int(dyMeters / blockSize.y)
        
        return .init(x: dx, y: dy)
    }
    
    private func movePlayer(dx: Int, dy: Int) {
        let newX = max(0, min(xCount - 1, playerPosition.x + dx))
        let newY = max(0, min(yCount - 1, playerPosition.y + dy))
        playerPosition = .init(x: newX, y: newY)
    }

    ///Расчитываем количество метров в одном блоке при изменении карты
    private func metersPerBlock(in mapWindow: YMKMapWindow) -> (x: Double, y: Double)? {
        
        let screenWidth = Float(mapWindow.width())
        let screenHeight = Float(mapWindow.height())

        let screenLeftBottom = YMKScreenPoint(x: 0, y: screenHeight)
        let screenRightBottom = YMKScreenPoint(x: screenWidth, y: screenHeight)
        let screenLeftTop = YMKScreenPoint(x: 0, y: 0)

        guard
            let worldLeftBottom = mapWindow.screenToWorld(with: screenLeftBottom),
            let worldRightBottom = mapWindow.screenToWorld(with: screenRightBottom),
            let worldLeftTop = mapWindow.screenToWorld(with: screenLeftTop)
        else {
            return nil
        }

        // Переводим в CLLocation
        let leftBottomLoc = CLLocation(latitude: worldLeftBottom.latitude, longitude: worldLeftBottom.longitude)
        let rightBottomLoc = CLLocation(latitude: worldRightBottom.latitude, longitude: worldRightBottom.longitude)
        let leftTopLoc = CLLocation(latitude: worldLeftTop.latitude, longitude: worldLeftTop.longitude)

        // Общая ширина и высота карты в метрах
        let mapWidthMeters = leftBottomLoc.distance(from: rightBottomLoc)
        let mapHeightMeters = leftBottomLoc.distance(from: leftTopLoc)

        // Размер блока
        return (
            x: mapWidthMeters / Double(Constants.SizeMap.cellSize),
            y: mapHeightMeters / Double(Constants.SizeMap.cellSize)
        )
    }
    
    private func isLocationMovedEnough(
        from oldLocation: CLLocation,
        to newLocation: CLLocation,
        threshold: CLLocationDistance
    ) -> Bool {
        let distance = newLocation.distance(from: oldLocation)
        return distance >= threshold
    }
}

//MARK: - output
extension FogMapManagerImpl {
    
    func start(subscribe: AnyPublisher<YMKMapView?, Never>)  {
        subscribe.assign(to: &$map)
    }
    
    func setPositionToCenter() {
        Task(priority: .userInitiated) {
            playerPosition = .center
            updateFog(from: .center)
            updateExploredArea()
        }
    }
}

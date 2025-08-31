import CoreLocation
import Combine

final class DefaultLocationService: NSObject, LocationServices {
    
    private let logger: LoggerManager
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private let locationSubject = CurrentValueSubject<[CLLocation]?, LocationError>(nil)
    private lazy var isAuthorizedSubject = CurrentValueSubject<Bool, Never>(locationManager.authorizationStatus.isAuthorized)
    
    private var locationSubscriberCount = 0
    
    init(logger: LoggerManager) {
        self.logger = logger
        super.init()
        
        setup()
    }
    
    private func setup() {
        self.locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 1
    }
    
    private func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}

extension DefaultLocationService {
    var locationPublisher: AnyPublisher<[CLLocation]?, LocationError> {
        locationSubject.handleEvents(
            receiveSubscription: { [weak self] _ in
                guard let self else { return }
                self.locationSubscriberCount += 1
                if self.locationSubscriberCount == 1 {
                    startLocationUpdates()
                }
            }, receiveCancel: { [weak self] in
                guard let self else { return }
                self.locationSubscriberCount -= 1
                if self.locationSubscriberCount == 0 {
                    stopLocationUpdates()
                }
            })
        .eraseToAnyPublisher()
    }
}

extension DefaultLocationService {
    var isAuthorizedPublisher: AnyPublisher<Bool, Never> {
        isAuthorizedSubject.eraseToAnyPublisher()
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    var isAuthorized: Bool {
        authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.log("LocationManager didFailWithError: \(error.localizedDescription)")
        let wrapped = LocationError.unknown(error)
        locationSubject.send(completion: .failure(wrapped))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.isAuthorizedSubject.send(status.isAuthorized)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else {
            logger.log("Error: Location unavailable")
            let error = LocationError.locationUnavailable
            locationSubject.send(completion: .failure(error))
            return
        }
        locationSubject.send(locations)
    }
}

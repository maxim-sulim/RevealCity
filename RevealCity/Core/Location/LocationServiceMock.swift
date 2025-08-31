import CoreLocation
import Combine

final class LocationSerivceMock: LocationService, LocationPermissionService {
    var isAuthorizedPublisher: AnyPublisher<Bool, Never> {
        $isauth.eraseToAnyPublisher()
    }
    
    var isAuthorized: Bool = false
    
    func requestAuthorization() {
        
    }
    @Published var isauth: Bool = false
    
    var locationPublisher: AnyPublisher<[CLLocation]?, LocationError> {
        locationSubject.eraseToAnyPublisher()
    }
    
    var authorizationStatus: CLAuthorizationStatus = .authorizedAlways
    
    
    private let locationSubject = CurrentValueSubject<[CLLocation]?, LocationError>(nil)
}

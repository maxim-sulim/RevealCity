import Combine
import CoreLocation

protocol LocationService {
    var locationPublisher: AnyPublisher<[CLLocation]?, LocationError> { get }
    var authorizationStatus: CLAuthorizationStatus { get }
}


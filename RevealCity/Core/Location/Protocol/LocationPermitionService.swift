import CoreLocation
import Combine

protocol LocationPermissionService {
    var isAuthorizedPublisher: AnyPublisher<Bool, Never> { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    var isAuthorized: Bool { get }

    func requestAuthorization()
}

import CoreLocation

extension CLAuthorizationStatus {
    
    var isAuthorized: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    var isDenied: Bool {
        switch self {
        case .denied, .restricted:
            return true
        default:
            return false
        }
    }
    
    var isNotDetermined: Bool {
        self == .notDetermined
    }
    
}

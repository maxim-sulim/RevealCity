import Foundation
import CoreLocation

struct LocationPoint: Codable, Equatable, Identifiable {
    var id: UUID
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let accuracy: Double
    
    init(coordinate: CLLocationCoordinate2D, accuracy: Double = 0, id: UUID = .init()) {
        self.id = id
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = .now
        self.accuracy = accuracy
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func distance(to other: LocationPoint) -> Double {
        let location1 = CLLocation(latitude: latitude, longitude: longitude)
        let location2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return location1.distance(from: location2)
    }
}

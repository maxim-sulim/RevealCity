//
//  LocationManagerMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//
import CoreLocation
import Combine

final class LocationSerivceMock: LocationService {
    
    @Published private var isLocationEnabled: Bool = true
    @Published private var currentLocation: CLLocation?
    
    var currentLocationPublisher: Published<CLLocation?>.Publisher { $currentLocation }
    var isLocationEnabledPublisher: Published<Bool>.Publisher { $isLocationEnabled }
    
    func checkIfLocationServicesEnabled() {
        
    }
    
    func startLocationUpdates() {
        
    }
    
    func stopLocationUpdates() {
        
    }
}

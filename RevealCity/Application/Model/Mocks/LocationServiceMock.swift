//
//  LocationManagerMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//
import CoreLocation
import Combine

final class LocationSerivceMock: LocationService {
    var isLocationEnabledPublisher: AnyPublisher<Bool, Never> {
        $isLocationEnabled.eraseToAnyPublisher()
    }
    
    var currentLocationPublisher: AnyPublisher<CLLocation?, Never> {
        $currentLocation.eraseToAnyPublisher()
    }
    
    
    @Published private var isLocationEnabled: Bool = true
    @Published private var currentLocation: CLLocation?
    
    func checkIfLocationServicesEnabled() {
        
    }
    
    func startLocationUpdates() {
        
    }
    
    func stopLocationUpdates() {
        
    }
}

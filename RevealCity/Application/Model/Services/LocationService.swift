//
//  LocationManager.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import CoreLocation
import Combine

protocol LocationService {
    var isLocationEnabledPublisher: AnyPublisher<Bool, Never> { get }
    var currentLocationPublisher: AnyPublisher<CLLocation?, Never> { get }
    
    func checkIfLocationServicesEnabled()
    func getCurrentCoordinates() -> CLLocationCoordinate2D?
}

final class LocationServiceImpl: NSObject, LocationService {
    
    private let logger: LoggerManager
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private var isLocationEnabled: CurrentValueSubject<Bool, Never> = .init(false)
    private var currentLocation: CurrentValueSubject<CLLocation?, Never> = .init(nil)
    
    var isLocationEnabledPublisher: AnyPublisher<Bool, Never> {
        isLocationEnabled.eraseToAnyPublisher()
    }
    
    var currentLocationPublisher: AnyPublisher<CLLocation?, Never> {
        currentLocation.eraseToAnyPublisher()
    }
    
    init(logger: LoggerManager) {
        self.logger = logger
        super.init()
        
        checkIfLocationServicesEnabled()
    }
    
    private func handleLocationStatus(_ status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            logger.log("Error: Location services are not authorized")
            stopLocationUpdates()
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationEnabled.send(true)
            startLocationUpdates()
        @unknown default:
            logger.log("Error: unknown error")
        }
    }
    
    private func startLocationUpdates() {
        guard isLocationEnabled.value else {
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    private func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        isLocationEnabled.send(false)
    }
    
    func getCurrentCoordinates() -> CLLocationCoordinate2D? {
        currentLocation.value?.coordinate
    }
    
    func checkIfLocationServicesEnabled() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.distanceFilter = 5
                locationManager.startUpdatingLocation()
                handleLocationStatus(locationManager.authorizationStatus)
            } else {
                logger.log("Error: Location services are not enabled")
            }
        }
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.log("Location error: \(error.localizedDescription)")
        isLocationEnabled.send(false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationStatus(status)
        logger.log("didChangeAuthorization:\(status)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation.send(locations.last)
    }
}

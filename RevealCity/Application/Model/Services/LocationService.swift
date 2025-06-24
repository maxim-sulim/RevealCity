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
}

final class LocationServiceImpl: NSObject, LocationService {
    
    private let logger = LoggerManagerImpl(configuration: .locationManager)
    private var locationManager: CLLocationManager?
    
    private var isLocationEnabled: CurrentValueSubject<Bool, Never> = .init(false)
    
    private var currentLocation: CurrentValueSubject<CLLocation?, Never> = .init(nil)
    
    var isLocationEnabledPublisher: AnyPublisher<Bool, Never> {
        isLocationEnabled.eraseToAnyPublisher()
    }
    
    var currentLocationPublisher: AnyPublisher<CLLocation?, Never> {
        currentLocation.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        
        checkIfLocationServicesEnabled()
    }
    
    
    private func handleLocationStatus(_ status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
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
    
    func checkIfLocationServicesEnabled() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                
                guard let locationManager = locationManager else { return }
                handleLocationStatus(locationManager.authorizationStatus)
            } else {
                logger.log("Error: Location services are not enabled")
            }
        }
    }
    
    private func startLocationUpdates() {
        guard isLocationEnabled.value else {
            return
        }
        
        guard let locationManager = locationManager else { return }
        
        locationManager.startUpdatingLocation()
    }
    
    private func stopLocationUpdates() {
        guard let locationManager = locationManager else { return }
        locationManager.stopUpdatingLocation()
        isLocationEnabled.send(false)
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.log("Location error: \(error.localizedDescription)")
        isLocationEnabled.send(false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        currentLocation.send(location)
    }
}

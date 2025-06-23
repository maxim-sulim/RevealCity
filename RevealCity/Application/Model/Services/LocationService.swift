//
//  LocationManager.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import CoreLocation
import UIKit.UIApplication

protocol LocationService {
    var isLocationEnabledPublisher: Published<Bool>.Publisher { get }
    var currentLocationPublisher: Published<CLLocation?>.Publisher { get }
    
    func checkIfLocationServicesEnabled()
    func startLocationUpdates()
    func stopLocationUpdates()
}

final class LocationServiceImpl: NSObject, LocationService {
    
    private let logger = LoggerManagerImpl(configuration: .locationManager)
    private var locationManager: CLLocationManager?
    
    @Published private var isLocationEnabled: Bool = false
    @Published private var currentLocation: CLLocation?
    
    var isLocationEnabledPublisher: Published<Bool>.Publisher { $isLocationEnabled }
    var currentLocationPublisher: Published<CLLocation?>.Publisher { $currentLocation }
    
    override init() {
        super.init()
        
        checkIfLocationServicesEnabled()
    }
    
    
    private func checlLocationAuthorizationStatus() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            logger.log("Error: Location services are not authorized")
            UIApplication.shared.showSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationEnabled = true
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
                checlLocationAuthorizationStatus()
            } else {
                logger.log("Error: Location services are not enabled")
            }
        }
    }
    
    func startLocationUpdates() {
        guard isLocationEnabled else {
            return
        }
        
        guard let locationManager = locationManager else { return }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        guard let locationManager = locationManager else { return }
        locationManager.stopUpdatingLocation()
        isLocationEnabled = false
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.log("Location error: \(error.localizedDescription)")
        isLocationEnabled = false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checlLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if location.horizontalAccuracy < 100 {
            currentLocation = location
        }
    }
}

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
    
    func checkIfLocationServicesEnabled()
}

final class LocationServiceImpl: NSObject, LocationService {
    
    private let logger = LoggerManagerImpl(configuration: .locationManager)
    private var locationManager: CLLocationManager?
    
    @Published private var isLocationEnabled: Bool = false
    
    var isLocationEnabledPublisher: Published<Bool>.Publisher { $isLocationEnabled }
    
    override init() {
        super.init()
        
        checkIfLocationServicesEnabled()
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
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.log("Location error: \(error.localizedDescription)")
        isLocationEnabled = false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checlLocationAuthorizationStatus()
    }
}

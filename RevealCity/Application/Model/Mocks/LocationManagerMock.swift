//
//  LocationManagerMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Combine

final class LocationSerivceMock: LocationService {
    
    @Published private var isLocationEnabled: Bool = true
    
    var isLocationEnabledPublisher: Published<Bool>.Publisher { $isLocationEnabled }
    
    func checkIfLocationServicesEnabled() {
        
    }
}

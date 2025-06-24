//
//  MKCoordinateRegion + ext.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import MapKit

extension MKCoordinateRegion {
    init() {
        self.init(center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
                  span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
    }
}

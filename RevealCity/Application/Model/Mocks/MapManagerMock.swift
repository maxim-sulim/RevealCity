//
//  MapManageMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//
import Combine
import MapKit

final class MapManagerMock: MapManager {
    
    var currentLocationPublished: Published<LocationPoint?>.Publisher { $currentLocation }
    var explorationDataPublished: Published<ExplorationData>.Publisher { $explorationData }
    var regionPublished: Published<MKCoordinateRegion>.Publisher { $region }
    
    @Published var currentLocation: LocationPoint?
    @Published var explorationData: ExplorationData = .init()
    @Published var region: MKCoordinateRegion = .init()
    
    func toMyselfLocation() {

    }
}

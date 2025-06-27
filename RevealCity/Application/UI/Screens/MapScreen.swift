//
//  MapScreen.swift
//  RevealCity
//
//  Created by Максим Сулим on 27.06.2025.
//

import SwiftUI
import YandexMapsMobile
import Combine
import CoreLocation

@MainActor
protocol YandexMapModel: ObservableObject {
    var mapView: YMKMapView? { get }
}

struct YandexMapView<Model: YandexMapModel>: UIViewRepresentable {
    
    @ObservedObject var model: Model
    
    func makeUIView(context: Context) -> YMKMapView {
        model.mapView ?? YMKMapView(frame: CGRect.zero)
    }
    
    func updateUIView(_ mapView: YMKMapView, context: Context) {}
}

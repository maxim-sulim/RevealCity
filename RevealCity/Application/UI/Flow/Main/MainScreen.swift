//
//  MainScreen.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import SwiftUI
import MapKit

struct MainScreen<ViewModel: MainViewModel>: View {
    
    @StateObject private var vm: ViewModel
    
    init(vm: @autoclosure @escaping () -> ViewModel) {
        _vm = StateObject(wrappedValue: vm())
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            map
                .ignoresSafeArea()
        }
        .onAppear {
            vm.dispatch(.onAppear)
        }
        .onDisappear {
            vm.dispatch(.onDisappear)
        }
        .safeAreaInset(edge: .bottom) {
            currentLocationButton
        }
    }
    
    private var map: some View {
        Map(coordinateRegion: $vm.region,
            annotationItems: vm.explorationData.exploredAreas) { area in
            MapAnnotation(coordinate: area.centerPoint.coordinate) {
                Circle()
                    .fill(.accent)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(.labelPrim, lineWidth: 2)
                    )
            }
        }
    }
    
    private var currentLocationButton: some View {
        Button(action: {
            vm.dispatch(.currentLocationTapped)
        }) {
            Image(systemName: "location")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.accent)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    let router = MainRouter(container: AppContainer(isPreview: true))
    let vm = MainViewModelImpl(coordinator: router,
                               locationService: LocationSerivceMock(),
                               mapManager: MapManagerMock())
    MainScreen(vm: vm)
}

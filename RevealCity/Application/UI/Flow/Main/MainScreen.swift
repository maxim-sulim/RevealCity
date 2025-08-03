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
            map
            fogLayer
        }
        .safeAreaInset(edge: .bottom) {
            currentLocationButton
        }
        .safeAreaInset(edge: .top, content: {
            exploredLabel
        })
        .onAppear {
            vm.dispatch(.onAppear)
        }
    }
    
    private var map: some View {
        YandexMapView(model: vm)
            .frame(width: Constants.SizeMap.width, height: Constants.SizeMap.height)
            .allowsHitTesting(false)
    }
    
    private var currentLocationButton: some View {
        Button {
            vm.dispatch(.currentLocationTapped)
        } label: {
            Image(systemName: SystemIcon.location.rawValue)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.accent)
                .clipShape(Circle())
        }
    }
    
    private var exploredLabel: some View {
        Text("Explored: \(vm.exploredPercent.trunc(2))%")
            .font(.title3)
            .foregroundColor(.accent)
    }
    
    private var fogLayer: some View {
        FogOfWarView(model: vm)
    }
}

#Preview {
    let router = MainRouter(container: AppContainer(isPreview: true))
    let vm = MainViewModelImpl(coordinator: router,
                               explorationMaanger: ExplorationMock(),
                               locationService: LocationSerivceMock(),
                               fogManager: FogManagerMock())
    MainScreen(vm: vm)
}

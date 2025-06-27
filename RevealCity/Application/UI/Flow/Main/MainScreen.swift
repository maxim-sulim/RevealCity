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
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom) {
            currentLocationButton
        }
        .safeAreaInset(edge: .top, content: {
            exploredLabel
                .padding(.top)
        })
        .onAppear {
            vm.dispatch(.onAppear)
        }
    }
    
    private var map: some View {
        YandexMapView(model: vm)
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
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
    private var exploredLabel: some View {
        Text("Explored: \(vm.exploredPercent.trunc(2))")
            .font(.title3)
            .foregroundColor(.accent)
    }
}

#Preview {
    let router = MainRouter(container: AppContainer(isPreview: true))
    let vm = MainViewModelImpl(coordinator: router,
                               locationService: LocationSerivceMock(),
                               explorationMaanger: ExplorationMock())
    MainScreen(vm: vm)
}

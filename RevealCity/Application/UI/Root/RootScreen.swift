//
//  RootScreen.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI

struct RootScreen<ViewModel: RootViewModel>: View {
    
    @AppStorage(Keys.Storage.onboardingKey.rawValue) var isOnboardingShown = true
    
    @StateObject private var vm: ViewModel
        
    init(vm: @escaping @autoclosure () -> ViewModel) {
        _vm = StateObject(wrappedValue: vm())
    }
    
    var body: some View {
        start()
            .withSlpashScreen(isShow: $vm.isSplashShow)
            .onAppear {
                vm.onApepar()
            }
    }
    
    @ViewBuilder
    private func start() -> some View {
        if isOnboardingShown {
            vm.onboardingFlow()
        } else {
            vm.mainFlow()
        }
    }
}


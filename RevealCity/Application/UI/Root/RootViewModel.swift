//
//  RootViewModel.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI

@MainActor
protocol RootViewModel: ObservableObject {
    var isOnboardingShown: Bool { get }
    var isSplashShow: Bool { get set }
    
    func onboardingFlow() -> OnboardingCoordinator
    func mainFlow() -> MainCoordinator
    func onApepar()
}

@MainActor
final class RootViewModelImpl: RootViewModel {
    
    private let router: any RootRouter
    private let onbStateManager: OnboardingStateInterface
    
    @Published var isOnboardingShown: Bool
    @Published var isSplashShow: Bool = false
    
    init(router: any RootRouter,
         onbStateManager: OnboardingStateInterface) {
        self.router = router
        self.onbStateManager = onbStateManager
        isOnboardingShown = onbStateManager.isOnboardingShown
    }
}

extension RootViewModelImpl {
    
    func onApepar()  {
        isSplashShow.toggle()
    }
    
    func onboardingFlow() -> OnboardingCoordinator {
        router.makeOnboardingCoordinator()
    }
    
    func mainFlow() -> MainCoordinator {
        router.makeMainCoordinator()
    }
}

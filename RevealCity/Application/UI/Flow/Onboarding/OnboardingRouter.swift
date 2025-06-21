//
//  OnboardingRouter.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import FlowStacks

@MainActor
final class OnboardRouter: ObservableObject {
    
    private var container: OnboardingContainer
    
    init(container: OnboardingContainer) {
        self.container = container
    }
    
    @Published var routes: Routes<OnboardLink> = []
    
    func makePolitic(from politic: Politic) -> PoliticScreen {
        PoliticScreen(configuration: politic)
    }
    
    func makeRootScreen() -> OnboardingScreen<OnboardingViewModel> {
        return OnboardingScreen(vm: OnboardingViewModel(coordinator: self,
                                                        appStateManager: self.container.makeAppStateManager(),
                                                        notificationManager: self.container.makeNotificationManager(),
                                                        locationService: self.container.makeLocationService()))
    }
}

extension OnboardRouter: OnboardingCoordinatorDelegate {
    func showPolitic(_ politic: Politic) {
        routes.presentSheet(.politic(politic))
    }
}

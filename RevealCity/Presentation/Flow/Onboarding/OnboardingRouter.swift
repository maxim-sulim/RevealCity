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
    
    func makeRootScreen() -> OnboardingScreen<OnboardingViewModelImpl> {
        return OnboardingScreen(vm: OnboardingViewModelImpl(coordinator: self,
                                                            appStateManager: self.container.makeAppStateManager(),
                                                            notificationManager: self.container.makeNotificationManager(),
                                                            locationService: self.container.makeLocationPermissionService()))
    }
}

extension OnboardRouter: OnboardingCoordinatorDelegate {
    func showPolitic(_ politic: Politic) {
        routes.presentSheet(.politic(politic))
    }
}

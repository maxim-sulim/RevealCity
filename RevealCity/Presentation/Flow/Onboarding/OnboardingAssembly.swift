@MainActor
protocol OnboardingContainer {
    func makeAppStateManager() -> OnboardingStateInterface
    func makeNotificationManager() -> NotificationManager
    func makeLocationService() -> LocationService
    func makeLocationPermissionService() -> LocationPermissionService
}

@MainActor
final class OnboardingAssembly {
    
    private let container: OnboardingContainer
    
    init(container: OnboardingContainer) {
        self.container = container
    }
    
    func coordinator() -> OnboardingCoordinator {
        return OnboardingCoordinator(router: OnboardRouter(container: self.container))
    }
}

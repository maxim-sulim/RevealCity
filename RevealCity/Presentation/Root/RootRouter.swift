import Foundation

@MainActor
protocol RootRouter: ObservableObject {
    func makeOnboardingCoordinator() -> OnboardingCoordinator
    func makeMainCoordinator() -> MainCoordinator
}

@MainActor
final class RootRouterImpl: RootRouter {
    
    private let container: RootContainer
    
    init(container: RootContainer) {
        self.container = container
    }
}

extension RootRouterImpl {
    func makeOnboardingCoordinator() -> OnboardingCoordinator {
        container.makeOnboardingAssembly().coordinator()
    }
    
    func makeMainCoordinator() -> MainCoordinator {
        container.makeMainAssembly().coordintor()
    }
}

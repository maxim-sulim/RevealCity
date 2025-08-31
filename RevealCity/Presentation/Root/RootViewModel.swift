import Foundation
import SwiftUI

@MainActor
protocol RootViewModel: ObservableObject {
    var isSplashShow: Bool { get set }
    
    func onboardingFlow() -> OnboardingCoordinator
    func mainFlow() -> MainCoordinator
    func onApepar()
}

@MainActor
final class RootViewModelImpl: RootViewModel {
    
    private let router: any RootRouter
    
    @Published var isSplashShow: Bool = false
    
    init(router: any RootRouter) {
        self.router = router
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

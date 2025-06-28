//
//  RootAssembly.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

@MainActor
protocol RootContainer {
    func makeAppStateManager() -> OnboardingStateInterface
    func makeOnboardingAssembly() -> OnboardingAssembly
    func makeMainAssembly() -> MainAssembly
}

@MainActor
final class RootAssembly {
    
    private let container: RootContainer
    
    init(container: RootContainer) {
        self.container = container
    }
    
    func view() -> RootScreen<RootViewModelImpl> {
        RootScreen(vm: RootViewModelImpl(router: RootRouterImpl(container: self.container),
                                         onbStateManager: self.container.makeAppStateManager()))
    }
}

import FlowStacks
import SwiftUI

enum OnboardLink: Equatable, Hashable {
    case politic(Politic)
}

struct OnboardingCoordinator: View {
    
    @StateObject private var router: OnboardRouter
    
    init(router: OnboardRouter) {
        self._router = StateObject(wrappedValue: router)
    }
    
    var body: some View {
        FlowStack($router.routes) {
            router.makeRootScreen()
                .flowDestination(for: OnboardLink.self) { screen in
                    switch screen {
                    case .politic(let politic):
                        router.makePolitic(from: politic)
                    }
                }
        }
    }
}


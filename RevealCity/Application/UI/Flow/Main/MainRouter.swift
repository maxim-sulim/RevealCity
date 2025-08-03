//
//  MainRouter.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import FlowStacks
import Foundation

@MainActor
final class MainRouter: ObservableObject {
    
    private var container: MainContainer
    
    init(container: MainContainer) {
        self.container = container
    }
    
    @Published var routes: Routes<MainLink> = []
    
    func makeRootScreen() -> MainScreen<MainViewModelImpl> {
        MainScreen(vm: MainViewModelImpl(coordinator: self,
                                         explorationMaanger: self.container.makeExplorationMaanger(),
                                         locationService: self.container.makeLocationService(),
                                         fogManager: self.container.makeFogManager()))
    }
}

extension MainRouter: MainCoordinatorDelegate {
    
}


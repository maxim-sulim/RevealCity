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
                                         locationService: self.container.makeLocationService(),
                                         mapManager: self.container.makeMapManager()))
    }
}

extension MainRouter: MainCoordinatorDelegate {
    
}


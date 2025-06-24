//
//  MainAssembly.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

@MainActor
protocol MainContainer {
    func makeLocationService() -> any LocationService
    func makeMapManager() -> MapManager
}

@MainActor
final class MainAssembly {
    
    private let container: MainContainer
    
    init(container: MainContainer) {
        self.container = container
    }
    
    func coordintor() -> MainCoordinator {
        MainCoordinator(router: .init(container: self.container))
    }
}

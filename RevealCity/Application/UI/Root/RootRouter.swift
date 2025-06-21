//
//  RootRouter.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation

@MainActor
protocol RootRouter: ObservableObject {
    
}

@MainActor
final class RootRouterImpl: RootRouter {
    
    private let container: RootContainer
    
    init(container: RootContainer) {
        self.container = container
    }
}

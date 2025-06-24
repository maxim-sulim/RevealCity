//
//  MainCoordinator.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import FlowStacks
import SwiftUI

enum MainLink: Equatable, Hashable {
    case link
    
}

struct MainCoordinator: View {
    
    @StateObject private var router: MainRouter
    
    init(router: MainRouter) {
        self._router = StateObject(wrappedValue: router)
    }
    
    var body: some View {
        FlowStack($router.routes) {
            router.makeRootScreen()
                .flowDestination(for: MainLink.self) { screen in
                    switch screen {
                    case .link:
                        EmptyView()
                    }
                }
        }
    }
}


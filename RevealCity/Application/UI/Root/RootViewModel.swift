//
//  RootViewModel.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI

@MainActor
protocol RootViewModel: ObservableObject {
    var isOnboardingShown: Bool { get }
}

@MainActor
final class RootViewModelImpl: RootViewModel {
    
    @AppStorage(.onboardingKey) var isOnboardingShown = true
    
    private let router: any RootRouter
    
    init(router: any RootRouter) {
        self.router = router
    }

    
}

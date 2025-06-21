//
//  ApplicationStateManager.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

protocol OnboardingStateInterface {
    var isOnboardingShown: Bool { get set }
    
    func completedOnboard()
}

final class ApplicationStateManager {
    
    @AppStorage(.onboardingKey) var isOnboardingShown = true
    
}

extension ApplicationStateManager: OnboardingStateInterface {
    
    func completedOnboard() {
        isOnboardingShown = false
    }
}


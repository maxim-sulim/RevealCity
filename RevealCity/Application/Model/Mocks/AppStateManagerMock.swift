//
//  AppStateManagerMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

final class AppStateManagerMock: OnboardingStateInterface {
    var isOnboardingShown: Bool = true
    
    func completedOnboard() {
        isOnboardingShown = false
    }
}

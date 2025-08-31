import SwiftUI

protocol OnboardingStateInterface {
    var isOnboardingShown: Bool { get set }
    
    func completedOnboard()
}

final class ApplicationStateManager {
    
    @AppStorage(Keys.Storage.onboardingKey.rawValue) var isOnboardingShown = true
    
}

extension ApplicationStateManager: OnboardingStateInterface {
    
    func completedOnboard() {
        isOnboardingShown = false
    }
}


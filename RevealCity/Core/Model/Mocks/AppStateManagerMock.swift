final class AppStateManagerMock: OnboardingStateInterface {
    var isOnboardingShown: Bool = true
    
    func completedOnboard() {
        isOnboardingShown = false
    }
}

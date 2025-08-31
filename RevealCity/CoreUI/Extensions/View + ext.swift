import SwiftUI

extension View {
    func withSlpashScreen(isShow: Binding<Bool>) -> some View {
        self.modifier(SplashModifier(isShow: isShow))
    }
}

extension View {
    func playHaptic(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
}

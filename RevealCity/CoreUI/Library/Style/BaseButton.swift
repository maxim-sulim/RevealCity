import Foundation
import SwiftUI

struct BaseButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    var height: CGFloat = 54
    var fillColor: Color = .accent
    
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(fillColor)
            .frame(height: height)
            .overlay {
                configuration.label
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .regular))
            }
            .opacity(isEnabled ? 1 : 0.6)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

extension ButtonStyle where Self == BaseButton {
    static var baseRounded: Self { Self() }
    static func baseRounded(height: CGFloat, fillColor: Color) -> Self {
        Self(height: height, fillColor: fillColor)
    }
}

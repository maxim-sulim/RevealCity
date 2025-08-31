import SwiftUI

struct PageControl: View {
    
    var pages: [Onboarding]
    
    @Binding var current: Onboarding
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(pages, id: \.self) { page in
                elementControl(for: page)
            }
        }
    }
    
    @ViewBuilder
    private func elementControl(for page: Onboarding) -> some View {
        if page == current {
            Rectangle()
                .fill(.accent)
                .frame(width: 22, height: 4)
                .clipShape(
                    RoundedRectangle(cornerRadius: 50)
                )
                .matchedGeometryEffect(id: "IndicatorAnimationId", in: animation)
        } else {
            Rectangle()
                .fill(.labelPrim.opacity(0.6))
                .frame(width: 10, height: 4)
                .clipShape(
                    RoundedRectangle(cornerRadius: 50)
                )
        }
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        PageControl(pages: Onboarding.allCases,
                    current: .constant(.page2))
            .padding()
    }
}

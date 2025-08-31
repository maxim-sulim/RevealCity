import SwiftUI

struct SplashInputModel {
    var iconAnimate: SystemIcon
    var title: String
    var message: String
}

extension SplashInputModel {
    init() {
        iconAnimate = .locCircleFill
        title = AppInfo().appName
        message = "Explore your city"
    }
}

struct SplashView: View {
    
    var inputModel: SplashInputModel
    
    @State private var isAnimating = false
    
    init(inputModel: SplashInputModel = .init()) {
        self.inputModel = inputModel
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: inputModel.iconAnimate.rawValue)
                    .font(.system(size: 80))
                    .foregroundStyle(.accent)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                VStack(spacing: 8) {
                    Text(inputModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .opacity(isAnimating ? 1.0 : 0.0)
                    
                    Text(inputModel.message)
                        .font(.title3)
                        .foregroundStyle(.labelPrim)
                        .opacity(isAnimating ? 1.0 : 0.0)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    SplashView()
}

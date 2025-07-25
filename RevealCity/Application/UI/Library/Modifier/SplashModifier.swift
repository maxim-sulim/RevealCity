//
//  SplashModifier.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

struct SplashModifier: ViewModifier {
    
    @Binding var isShow: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                SplashView()
                    .opacity(isShow ? 1 : 0)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isShow = false
                            }
                        }
                    }
            }
    }
}

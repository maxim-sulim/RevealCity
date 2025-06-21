//
//  SplashView.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            //TODO: labels value
            VStack(spacing: 24) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.accent)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                VStack(spacing: 8) {
                    Text("RevealCity")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .opacity(isAnimating ? 1.0 : 0.0)
                    
                    Text("Explore your city")
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

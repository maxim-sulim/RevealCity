//
//  OnboardingPage.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

struct OnboardingPage: View {
    let model: PageModel
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: model.icon.rawValue)
                .font(.system(size: 80))
                .foregroundStyle(model.color)
            
            VStack(spacing: 16) {
                Text(model.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(model.description)
                    .font(.body)
                    .foregroundStyle(.labelPrim)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .frame(height: 170, alignment: .top)
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(.horizontal, 32)
    }
}


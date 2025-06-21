//
//  PermissionPage.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

struct PermissionPage: View {
    
    @Binding var isNotificationGranted: Bool
    @Binding var isLocationGranted: Bool
    
    var onLocationPerTapped: () -> Void
    var onNotificationPerTapped: () -> Void
    var onNextTapped: () -> Void
    var onTapPolicit: (Politic) -> Void
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                header
                
                VStack(spacing: 32) {
                    Image(systemName: "location.circle")
                        .font(.system(size: 120))
                        .foregroundStyle(.accent)
                }
                
                VStack(spacing: 24) {
                    Button {
                        onLocationPerTapped()
                    } label: {
                        PermissionLabel(
                            icon: "location.fill",
                            title: "Location Access",
                            description: "Track your exploration and reveal new areas",
                            isGranted: isLocationGranted,
                        )
                    }
                    .disabled(isLocationGranted)
                    
                    Button {
                        onNotificationPerTapped()
                    } label: {
                        PermissionLabel(
                            icon: "bell.fill",
                            title: "Notifications",
                            description: "Get reminders to explore and celebrate achievements",
                            isGranted: isNotificationGranted
                        )
                    }
                    .disabled(isNotificationGranted)
                }
                
                Spacer()
                
                Button("Continue") {
                    withAnimation {
                        onNextTapped()                        
                    }
                }
                .buttonStyle(.baseRounded)
                .padding(.horizontal, 24)
                .disabled(!isLocationGranted || !isNotificationGranted)
                .opacity(isLocationGranted && isNotificationGranted ? 1 : 0.6)
            }
            .padding(.vertical, 40)
        }
        .safeAreaInset(edge: .bottom) {
            PolicyView(policyTapped: onTapPolicit)
        }
    }
    
    private var header: some View {
        VStack(spacing: 16) {
            Text("Permissions")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text("We need a few permissions to make your exploration experience amazing")
                .font(.body)
                .foregroundStyle(.labelPrim)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

#Preview {
    PermissionPage(isNotificationGranted: .constant(false),
                   isLocationGranted: .constant(true),
                   onLocationPerTapped: { },
                   onNotificationPerTapped: { },
                   onNextTapped: { },
                   onTapPolicit: { _ in})
}

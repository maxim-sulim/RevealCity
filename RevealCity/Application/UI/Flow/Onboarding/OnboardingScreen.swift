//
//  OnboardingScreen.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI

struct OnboardingScreen<ViewModel: OnboardingViewModel>: View {
    
    @StateObject private var vm: ViewModel
    
    init(vm: @autoclosure @escaping () -> ViewModel) {
        _vm = StateObject(wrappedValue: vm())
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 40) {
                header
                
                TabView(selection: $vm.currentPage, content: pages)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.default, value: vm.currentPage)
                
                nextButton
                    .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 40)
            .safeAreaInset(edge: .bottom) {
                PolicyView(policyTapped: vm.politicTapped(_:))
            }
        }
        .overlay {
            PermissionPage(isNotificationGranted: $vm.isNotificationGranted,
                           isLocationGranted: $vm.isLocationGranted,
                           onLocationPerTapped: vm.locationPermTapped,
                           onNotificationPerTapped: vm.notificationPermTapped,
                           onNextTapped: vm.closePermissionView,
                           onTapPolicit: vm.politicTapped(_:))
            .opacity(vm.isShowPermissionView ? 1 : 0)
            .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private func pages() -> some View {
        ForEach(vm.pagesOnboard, id: \.self) { page in
            OnboardingPage(model: page.inputModel)
                .onAppear {
                    playHaptic(.light)
                }
        }
    }
    
    private var header: some View {
        VStack(spacing: 16) {
            Text("Welcome to Loccator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text("Your personal city exploration companion")
                .font(.body)
                .foregroundStyle(.labelPrim)
                .multilineTextAlignment(.center)
        }
    }
    
    private var nextButton: some View {
        VStack(spacing: 12) {
            Button(vm.titleButton) {
                vm.nextTapped()
            }
            .buttonStyle(.baseRounded)
        }
    }
}

#Preview {
    let router = OnboardRouter(container: AppContainer(isPreview: true))
    let vm = OnboardingViewModel(coordinator: router,
                                 appStateManager: AppStateManagerMock(),
                                 notificationManager: NotificationManagerMock(),
                                 locationService: LocationSerivceMock())
    OnboardingScreen(vm: vm)
}

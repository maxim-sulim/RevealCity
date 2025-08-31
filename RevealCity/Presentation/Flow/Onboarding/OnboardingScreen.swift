import Foundation
import SwiftUI

struct OnboardingScreen<ViewModel: OnboardingViewModelInterface>: View {
    
    @StateObject private var vm: ViewModel
    
    init(vm: @autoclosure @escaping () -> ViewModel) {
        _vm = StateObject(wrappedValue: vm())
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                header
                
                TabView(selection: $vm.currentPage, content: pages)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(maxHeight: .infinity, alignment: .center)
                
                VStack(spacing: 22) {
                    PageControl(pages: vm.inputModel.pages,
                                current: $vm.currentPage)
                    
                    nextButton
                        .padding(.horizontal, 24)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: vm.currentPage)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 40)
            .safeAreaInset(edge: .bottom) {
                PolicyView { politic in
                    vm.dispatch(.politicTapped(politic))
                }
            }
        }
        .overlay {
            PermissionPage(isNotificationGranted: $vm.isNotificationGranted,
                           isLocationGranted: $vm.isLocationGranted,
                           inputModel: vm.inputModel.permissionPageInput,
                           onDispatch: vm.dispatch(_:))
            .opacity(vm.isShowPermissionView ? 1 : 0)
            .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private func pages() -> some View {
        ForEach(vm.inputModel.pages, id: \.self) { page in
            OnboardingPage(model: page.inputModel)
                .onAppear {
                    playHaptic(.light)
                }
        }
    }
    
    private var header: some View {
        VStack(spacing: 16) {
            Text(vm.inputModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(vm.inputModel.subtitle)
                .font(.body)
                .foregroundStyle(.labelPrim)
                .multilineTextAlignment(.center)
        }
    }
    
    private var nextButton: some View {
        VStack(spacing: 12) {
            Button(vm.titleButton) {
                vm.dispatch(.nextTapped)
            }
            .buttonStyle(.baseRounded)
        }
    }
}

#Preview {
    let router = OnboardRouter(container: AppContainer(isPreview: true))
    let vm = OnboardingViewModelImpl(coordinator: router,
                                     appStateManager: AppStateManagerMock(),
                                     notificationManager: NotificationManagerMock(),
                                     locationService: LocationSerivceMock())
    OnboardingScreen(vm: vm)
}

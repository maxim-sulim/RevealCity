import SwiftUI

struct PermissionPage: View {
    
    var inputModel: PermissionPageInputModel
    @Binding var isNotificationGranted: Bool
    @Binding var isLocationGranted: Bool
    
    private var onDispatch: (OnboardingViewModelImpl.Event) -> Void
    
    init(isNotificationGranted: Binding<Bool>,
         isLocationGranted: Binding<Bool>,
         inputModel: PermissionPageInputModel,
         onDispatch: @escaping (OnboardingViewModelImpl.Event) -> Void) {
        _isNotificationGranted = isNotificationGranted
        _isLocationGranted = isLocationGranted
        self.inputModel = inputModel
        self.onDispatch = onDispatch
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                header
                
                Group {
                    icon
                    permissionsLabel
                }
                .frame(maxHeight: .infinity, alignment: .center)
                
                contiuneButton
            }
            .padding(.vertical, 40)
        }
        .safeAreaInset(edge: .bottom) {
            PolicyView { politic in
                onDispatch(.politicTapped(politic))
            }
        }
    }
    
    private var icon: some View {
        Image(systemName: SystemIcon.locationCircle.rawValue)
            .font(.system(size: 120))
            .foregroundStyle(.accent)
    }
    
    private var permissionsLabel: some View {
        VStack(spacing: 24) {
            Button {
                onDispatch(.locationPermTapped)
            } label: {
                PermissionLabel(
                    icon: SystemIcon.locationFill,
                    title: inputModel.locationLabelTitle,
                    description: inputModel.locationDescription,
                    isGranted: isLocationGranted,
                )
            }
            .disabled(isLocationGranted)
            .animation(.default, value: isLocationGranted)
            
            Button {
                onDispatch(.notificationPermTapped)
            } label: {
                PermissionLabel(
                    icon: SystemIcon.bell,
                    title: inputModel.notificationLabelTitle,
                    description: inputModel.notificationDescription,
                    isGranted: isNotificationGranted
                )
            }
            .disabled(isNotificationGranted)
            .animation(.default, value: isNotificationGranted)
        }
    }
    
    private var header: some View {
        VStack(spacing: 16) {
            Text(inputModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(inputModel.subtitle)
                .font(.body)
                .foregroundStyle(.labelPrim)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private var contiuneButton: some View {
        Button(inputModel.continueButton) {
            withAnimation {
                onDispatch(.closePermissionView)
            }
        }
        .buttonStyle(.baseRounded)
        .padding(.horizontal, 24)
        .disabled(!isLocationGranted || !isNotificationGranted)
        .opacity(isLocationGranted && isNotificationGranted ? 1 : 0.6)
    }
}

#Preview {
    PermissionPage(isNotificationGranted: .constant(true),
                   isLocationGranted: .constant(false),
                   inputModel: .init(),
                   onDispatch: { _ in })
}

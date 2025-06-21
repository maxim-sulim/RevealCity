//
//  OnboardingViewModel.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
protocol OnboardViewModelIntarface: ObservableObject {
    
    var isLocationGranted: Bool { get set }
    var isNotificationGranted: Bool { get set }
    var currentPage: Onboarding { get set }
    var isShowPermissionView: Bool { get }
    var pagesOnboard: [Onboarding] { get }
    var titleButton: String { get }
    
    func closePermissionView()
    func nextTapped()
    func politicTapped(_ politic: Politic)
    func onboardingComplated()
    func notificationPermTapped()
    func locationPermTapped()
}

@MainActor
protocol OnboardingCoordinatorDelegate: Any {
    
    func showPolitic(_ politic: Politic)
}

@MainActor
final class OnboardingViewModel: OnboardViewModelIntarface {
    
    private let locationService: LocationService
    private let notificationManager: NotificationManager
    private let applicationManager: OnboardingStateInterface
    private let coordinator: OnboardingCoordinatorDelegate
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var pagesOnboard: [Onboarding] = Onboarding.allCases
    @Published var isShowPermissionView: Bool = true
    @Published var currentPage: Onboarding = .page1
    
    @Published var isLocationGranted: Bool = false
    @Published var isNotificationGranted: Bool = false
    @Published var titleButton: String = ""
    
    init(coordinator: OnboardingCoordinatorDelegate,
         appStateManager: OnboardingStateInterface,
         notificationManager: NotificationManager,
         locationService: LocationService) {
        self.coordinator = coordinator
        self.applicationManager = appStateManager
        self.notificationManager = notificationManager
        self.locationService = locationService
        
        setup()
        bind()
    }
    
    private func setup() {
        notificationManager.checkNotificationPermission()
        locationService.checkIfLocationServicesEnabled()
    }
    
    private func bind() {
        locationService.isLocationEnabledPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$isLocationGranted)
        
        notificationManager.notificationPermissionGrantedPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$isNotificationGranted)
        
        $currentPage
            .receive(on: RunLoop.main)
            .sink { [weak self] page in
                guard let self else { return }
                
                updateUI(for: page)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(for page: Onboarding) {
        switch page {
        case .page1:
            titleButton = "Next"
        case .page2:
            titleButton = "Next"
        case .page3:
            titleButton = "Get started"
        }
    }
}

extension OnboardingViewModel {
    
    func notificationPermTapped() {
        
    }
    
    func locationPermTapped() {
        
    }
    
    func closePermissionView() {
        isShowPermissionView.toggle()
    }
   
    func nextTapped() {
        switch currentPage {
        case .page1:
            currentPage = .page2
        case .page2:
            currentPage = .page3
        case .page3:
            onboardingComplated()
        }
    }
    
    func onboardingComplated() {
        applicationManager.completedOnboard()
    }
    
    func politicTapped(_ politic: Politic) {
        coordinator.showPolitic(politic)
    }
}

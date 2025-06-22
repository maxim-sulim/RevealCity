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
protocol OnboardingViewModelInterface: ObservableObject {
    
    var isLocationGranted: Bool { get set }
    var isNotificationGranted: Bool { get set }
    var currentPage: Onboarding { get set }
    var isShowPermissionView: Bool { get }
    var inputModel: OnboardingInputModel { get }
    var titleButton: String { get }
    
    func dispatch(_ event: OnboardingViewModelImpl.Event)
}

@MainActor
protocol OnboardingCoordinatorDelegate: Any {
    
    func showPolitic(_ politic: Politic)
}

@MainActor
final class OnboardingViewModelImpl: OnboardingViewModelInterface {
    
    enum Event {
        case closePermissionView
        case nextTapped
        case notificationPermTapped
        case locationPermTapped
        case onboardingComplated
        case politicTapped(_ politic: Politic)
    }
    
    private let locationService: LocationService
    private let notificationManager: NotificationManager
    private let applicationManager: OnboardingStateInterface
    private let coordinator: OnboardingCoordinatorDelegate
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var inputModel: OnboardingInputModel
    @Published var isShowPermissionView: Bool = true
    @Published var currentPage: Onboarding = .page1
    
    @Published var isLocationGranted: Bool = false
    @Published var isNotificationGranted: Bool = false
    @Published var titleButton: String = ""
    
    init(inputModel:OnboardingInputModel = .init(),
         coordinator: OnboardingCoordinatorDelegate,
         appStateManager: OnboardingStateInterface,
         notificationManager: NotificationManager,
         locationService: LocationService) {
        self.coordinator = coordinator
        self.applicationManager = appStateManager
        self.notificationManager = notificationManager
        self.locationService = locationService
        self.inputModel = inputModel
        
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
            titleButton = inputModel.titleNextButton
        case .page2:
            titleButton = inputModel.titleNextButton
        case .page3:
            titleButton = inputModel.titleLastButton
        }
    }
    
    private func notificationPermTapped() {
        notificationManager.checkNotificationPermission()
    }
    
    private func locationPermTapped() {
        locationService.checkIfLocationServicesEnabled()
    }
    
    private func closePermissionView() {
        isShowPermissionView.toggle()
    }
   
    private func nextTapped() {
        switch currentPage {
        case .page1:
            currentPage = .page2
        case .page2:
            currentPage = .page3
        case .page3:
            onboardingComplated()
        }
    }
    
    private func onboardingComplated() {
        applicationManager.completedOnboard()
    }
    
    private func politicTapped(_ politic: Politic) {
        coordinator.showPolitic(politic)
    }
}

extension OnboardingViewModelImpl {
    
    func dispatch(_ event: Event) {
        switch event {
        case .closePermissionView:
            closePermissionView()
        case .nextTapped:
            nextTapped()
        case .notificationPermTapped:
            notificationPermTapped()
        case .locationPermTapped:
            locationPermTapped()
        case .onboardingComplated:
            onboardingComplated()
        case .politicTapped(let politic):
            politicTapped(politic)
        }
    }
}

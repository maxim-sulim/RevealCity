//
//  OnboardingInputModel.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI

struct OnboardingInputModel {
    let pages: [Onboarding]
    let title: String
    let subtitle: String
    let titleNextButton: String
    let titleLastButton: String
    let permissionPageInput: PermissionPageInputModel
}

extension OnboardingInputModel {
    init(_ permissionInput: PermissionPageInputModel = .init()) {
        pages = Onboarding.allCases
        title = "Welcome to RevealCity"
        subtitle = "Your personal city exploration companion"
        titleNextButton = "Next"
        titleLastButton = "Get started"
        permissionPageInput = permissionInput
    }
}

struct PermissionPageInputModel {
    let title: String
    let subtitle: String
    let continueButton: String
    let locationLabelTitle: String
    let locationDescription: String
    let notificationLabelTitle: String
    let notificationDescription: String
}

extension PermissionPageInputModel {
    init() {
        title = "Permissions"
        subtitle = "We need a few permissions to make your exploration experience amazing"
        continueButton = "Continue"
        locationDescription = "Track your exploration and reveal new areas"
        locationLabelTitle = "Location Access"
        notificationDescription = "Get reminders to explore and celebrate achievements"
        notificationLabelTitle = "Notifications"
    }
}

enum Onboarding: String, RawRepresentable, CaseIterable, Identifiable, Equatable {
    case page1, page2, page3
    
    var id: String {
        rawValue
    }
    
    var inputModel: PageModel {
        switch self {
        case .page1:  PageModel(from: .page1)
        case .page2: PageModel(from: .page2)
        case .page3: PageModel(from: .page3)
        }
    }
}

extension Onboarding {
    static func == (lhs: Onboarding, rhs: Onboarding) -> Bool {
        lhs.id == rhs.id
    }
}

struct PageModel: Identifiable, Hashable {
    var id: String
    let icon: SystemIcon
    let title: String
    let description: String
    let color: Color
}

extension PageModel {
    init(from configure: Onboarding) {
        id = configure.rawValue
        switch configure {
        case .page1:
            icon = .walk
            title = "Active Exploration"
            description = "Walk through your city and reveal hidden areas on your personal map"
            color = .labelPrim
        case .page2:
            icon = .chartLine
            title = "Track Progress"
            description = "Monitor your steps, distance, and exploration percentage with beautiful charts"
            color = .accent
        case .page3:
            icon = .map
            title = "Discover Your City"
            description = "Unlock badges and achievements as you explore more of your surroundings"
            color = .labelPrim
        }
    }
}


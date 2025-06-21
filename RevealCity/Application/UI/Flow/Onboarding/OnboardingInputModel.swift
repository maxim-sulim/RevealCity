//
//  OnboardingInputModel.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI

enum Onboarding: Int, CaseIterable {
    case page1, page2, page3
    
    var id: String {
        UUID().uuidString
    }
    
    var inputModel: PageModel {
        switch self {
        case .page1:  PageModel(from: .page1)
        case .page2: PageModel(from: .page2)
        case .page3: PageModel(from: .page3)
        }
    }
}

struct PageModel: Hashable, Identifiable {
    var id: UUID = UUID()
    let icon: String
    let title: String
    let description: String
    let color: Color
}

extension PageModel {
    init(from configure: Onboarding) {
        switch configure {
        case .page1:
            icon = "figure.walk.circle"
            title = "Active Exploration"
            description = "Walk through your city and reveal hidden areas on your personal map"
            color = .labelPrim
        case .page2:
            icon = "chart.line.uptrend.xyaxis"
            title = "Track Progress"
            description = "Monitor your steps, distance, and exploration percentage with beautiful charts"
            color = .accent
        case .page3:
            icon = "map.circle"
            title = "Discover Your City"
            description = "Unlock badges and achievements as you explore more of your surroundings"
            color = .labelPrim
        }
    }
}


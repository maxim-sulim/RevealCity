//
//  RootScreen.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Foundation
import SwiftUI

struct RootScreen<ViewModel: RootViewModel>: View {
    
    @StateObject private var vm: ViewModel
    
    init(vm: @escaping @autoclosure () -> ViewModel) {
        _vm = StateObject(wrappedValue: vm())
    }
    
    var body: some View {
        start()
    }
    
    @ViewBuilder
    private func start() -> some View {
        if vm.isOnboardingShown {
            EmptyView()
        } else {
            EmptyView()
        }
    }
}


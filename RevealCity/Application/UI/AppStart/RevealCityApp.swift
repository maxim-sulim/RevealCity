//
//  RevealCityApp.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

@main
struct RevealCityApp: App {
    
    @StateObject var appContainer = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            appContainer.makeRootAssembly().view()
        }
    }
}

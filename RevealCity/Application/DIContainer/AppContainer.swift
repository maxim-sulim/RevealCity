//
//  AppContainer.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

@MainActor
final class AppContainer: ObservableObject {
    
    private var weakDependencies = [String: WeakContainer]()
    
    init(isPreview: Bool = false) {
        
    }
    
    private func getWeak<T: AnyObject>(initialize: () -> T) -> T {
        let id = String(describing: T.self)
        
        if let dependency = weakDependencies[id]?.object as? T {
            return dependency
        }
        
        let object = initialize()
        weakDependencies[id] = .init(object: object)
        
        return object
    }
}

extension AppContainer {
    func makeRootAssembly() -> RootAssembly {
        RootAssembly(container: self)
    }
    
}

extension AppContainer: RootContainer {
    
}

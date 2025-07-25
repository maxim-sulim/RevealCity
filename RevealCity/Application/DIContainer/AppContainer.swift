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
    private let isPreview: Bool
    
    private let locationService: LocationService
    private let explorationManager: ExplorationObserver
    
    init(isPreview: Bool = false) {
        self.isPreview = isPreview
        
        locationService = isPreview
        ? LocationSerivceMock()
        : LocationServiceImpl(logger: LoggerManagerImpl(configuration: .locationManager))
        
        explorationManager = isPreview
        ? ExplorationMock()
        : ExplorationObserverImpl(locationService: locationService,
                                 keychainService: .init(),
                                 logger: LoggerManagerImpl(configuration: .explorationManager))
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
        .init(container: self)
    }
}

extension AppContainer: RootContainer {
    func makeMainAssembly() -> MainAssembly {
        .init(container: self)
    }
    
    func makeOnboardingAssembly() -> OnboardingAssembly {
        .init(container: self)
    }
}

extension AppContainer: OnboardingContainer {
    func makeAppStateManager() -> any OnboardingStateInterface {
        getWeak {
            ApplicationStateManager()
        }
    }
    
    func makeNotificationManager() -> any NotificationManager {
        getWeak {
            NotificationManagerImpl()
        }
    }
    
    func makeLocationService() -> any LocationService {
        locationService
    }
}

extension AppContainer: MainContainer {
    func makeExplorationMaanger() -> any ExplorationObserver {
        explorationManager
    }
}

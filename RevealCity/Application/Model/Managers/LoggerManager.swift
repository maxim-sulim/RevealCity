//
//  LoggerManager.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import OSLog

protocol LoggerManager {
    func log(_ message: String)
}

final class LoggerManagerImpl {
    
    enum Configuration: String {
        case locationManager
        
        var categoty: String {
            switch self {
            case .locationManager: "Manager"
            }
        }
        
        var name: String {
            switch self {
            case .locationManager: "LocationManager: -"
            }
        }
    }
    
    private let configuration: Configuration
    
    lazy private var logger: Logger = {
        Logger(subsystem: configuration.rawValue, category: configuration.categoty)
    }()
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension LoggerManagerImpl {
    
    func log(_ message: String) {
        logger.info("\(self.configuration.name) \(message)")
    }
}

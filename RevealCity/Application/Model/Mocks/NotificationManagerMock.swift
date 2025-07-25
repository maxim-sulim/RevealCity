//
//  NotificationManagerMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Combine

final class NotificationManagerMock: NotificationManager {
    
    var notificationPermissionGrantedPublisher: AnyPublisher<Bool, Never> { $notificationPermissionGranted.eraseToAnyPublisher() }
    
    @Published private var notificationPermissionGranted: Bool = true
    
    
    func checkNotificationPermission() {
        
    }
}

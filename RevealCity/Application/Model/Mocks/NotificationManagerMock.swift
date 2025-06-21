//
//  NotificationManagerMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import Combine

final class NotificationManagerMock: NotificationManager {
    
    @Published private var notificationPermissionGranted: Bool = true
    
    var notificationPermissionGrantedPublisher: Published<Bool>.Publisher { $notificationPermissionGranted }
    
    func checkNotificationPermission() {
        
    }
}

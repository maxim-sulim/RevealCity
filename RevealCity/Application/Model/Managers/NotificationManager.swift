//
//  PermissonMaanger.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import UserNotifications
import CoreLocation
import UIKit.UIApplication

protocol NotificationManager {
    var notificationPermissionGrantedPublisher: Published<Bool>.Publisher { get }
    
    func checkNotificationPermission()
}

final class NotificationManagerImpl: NotificationManager {
    
    var notificationPermissionGrantedPublisher: Published<Bool>.Publisher { $notificationPermissionGranted }
    
    @Published private var notificationPermissionGranted: Bool = false
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async { [weak self] in
                self?.notificationPermissionGranted = granted
            }
        }
    }
    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self?.requestNotificationPermission()
            case .authorized, .ephemeral, .provisional:
                self?.notificationPermissionGranted = true
            @unknown default:
                break
            }
            
        }
    }
}

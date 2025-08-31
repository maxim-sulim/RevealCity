import UserNotifications
import Combine

protocol NotificationManager {
    var notificationPermissionGrantedPublisher: AnyPublisher<Bool, Never> { get }
    
    func checkNotificationPermission()
}

final class NotificationManagerImpl: NotificationManager {
    
    var notificationPermissionGrantedPublisher: AnyPublisher<Bool, Never> {
        notificationPermissionGranted.eraseToAnyPublisher()
    }
    
    private var notificationPermissionGranted: CurrentValueSubject<Bool, Never> = .init(false)
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            self.notificationPermissionGranted.send(granted)
        }
    }
    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self?.requestNotificationPermission()
            case .authorized, .ephemeral, .provisional:
                self?.notificationPermissionGranted.send(true)
            @unknown default:
                break
            }
            
        }
    }
}

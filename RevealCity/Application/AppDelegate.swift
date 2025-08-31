import UIKit
import YandexMapsMobile

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupMapKit()
        return true
    }
    
    private func setupMapKit() {
        YMKMapKit.setApiKey(Keys.API.map.rawValue)
        YMKMapKit.sharedInstance()
    }
}

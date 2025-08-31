import SwiftUI

@main
struct RevealCityApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var appContainer = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            appContainer.makeRootAssembly().view()
        }
    }
}

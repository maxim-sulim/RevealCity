//
//  AppInfo.swift
//  RevealCity
//
//  Created by Максим Сулим on 22.06.2025.
//

struct AppInfo {
    enum URLSheme {
        case shareApp
        case review
    }
    
    let appID: String = ""
    let appName: String = "RevealCity"
    
    func path(from shame: URLSheme) -> String {
        switch shame {
        case .shareApp: "https://apps.apple.com/app/id\(appID)"
        case .review: "https://apps.apple.com/app/id\(appID)?action=write-review"
        }
    }
}

//
//  UIApplication + ext.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

extension UIApplication {
    
   static func currentWindowScene() -> UIWindowScene? {
        UIApplication
            .shared
            .connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
   }
    
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

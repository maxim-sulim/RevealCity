//
//  Double + ext.swift
//  RevealCity
//
//  Created by Максим Сулим on 28.06.2025.
//

import Foundation

extension Double {
    func trunc(_ decimal:Int) -> String {
        String(format: "%.\(decimal)f", self)
    }
}

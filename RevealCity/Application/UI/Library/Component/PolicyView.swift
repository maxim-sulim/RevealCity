//
//  PolicyView.swift
//  RevealCity
//
//  Created by Максим Сулим on 22.06.2025.
//

import SwiftUI

struct PolicyView: View {
    
    private var policyTapped: (Politic) -> Void
    
    init(policyTapped: @escaping (Politic) -> Void) {
        self.policyTapped = policyTapped
    }
    
    var body: some View {
        HStack(spacing: 44) {
            PolicyButton(title: "Privacy Policy",
                          size: 14) {
                policyTapped(.policy)
            }
            PolicyButton(title: "Terms of Use",
                          size: 14) {
                policyTapped(.terms)
            }
        }
    }
}

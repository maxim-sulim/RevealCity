//
//  PoliticButton.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//

import SwiftUI

struct PolicyButton: View {
    
    var title: String
    var size: CGFloat
    
    private var action: () -> Void
    
    init(title: String, size: CGFloat, action: @escaping () -> Void) {
        self.title = title
        self.size = size
        self.action = action
    }
    
    var body: some View {
        linkButton(title: title,
                   size: size,
                   action: action)
    }
    
    @ViewBuilder
    private func linkButton(title: String,
                            size: CGFloat,
                            action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: size))
                Line(axis: .horizontal)
                    .stroke(lineWidth: 0.5)
                    .frame(height: 0.5)
            }
            .foregroundStyle(.black.opacity(0.4))
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}

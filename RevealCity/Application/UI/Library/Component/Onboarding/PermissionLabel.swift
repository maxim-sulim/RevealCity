//
//  PermissionButton.swift
//  RevealCity
//
//  Created by Максим Сулим on 21.06.2025.
//
import SwiftUI

struct PermissionLabel: View {
    let icon: SystemIcon
    let title: String
    let description: String
    let isGranted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon.rawValue)
                .font(.title2)
                .foregroundStyle(isGranted ? .accent : .labelPrim)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.labelPrim)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.labelPrim)
                    .lineLimit(2)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if isGranted {
                Image(systemName: SystemIcon.checkmark.rawValue)
                    .font(.title2)
                    .foregroundStyle(.accent)
            } else {
                Text("Allow")
                .font(.caption)
                .foregroundStyle(.orange1)
            }
        }
        .padding(20)
        .background(.bg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        PermissionLabel(icon: SystemIcon.location,
                        title: "Location Access",
                        description: "Track your exploration and reveal new areas",
                        isGranted: true)
        .padding()
    }
}

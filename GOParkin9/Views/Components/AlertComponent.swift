//
//  AlertComponent.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 31/03/25.
//

import SwiftUI

struct AlertComponent: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmAction: (() -> Void)?
    
    let cancelButtonText: String
    let confirmButtonText: String
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button(cancelButtonText, role: .cancel) { }
                if let action = confirmAction {
                    Button(confirmButtonText, role: .destructive, action: action)
                }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func alertComponent(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmAction: (() -> Void)? = nil,
        cancelButtonText: String = "Cancel",
        confirmButtonText: String = "Confirm"
    ) -> some View {
        self.modifier(
            AlertComponent(
                isPresented: isPresented,
                title: title,
                message: message,
                confirmAction: confirmAction,
                cancelButtonText: cancelButtonText,
                confirmButtonText: confirmButtonText
            )
        )
    }
}

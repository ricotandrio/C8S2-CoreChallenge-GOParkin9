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
    
    let cancelAction: (() -> Void)?
    let cancelButtonText: String
    let cancelButtonRole: ButtonRole?
    let hideCancelButton: Bool
    
    let confirmAction: (() -> Void)?
    let confirmButtonText: String
    let confirmButtonRole: ButtonRole?
    let hideConfirmButton: Bool
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                
                if !hideCancelButton {
                    
                    Button(role: cancelButtonRole) {
                        if let _ = cancelAction {
                            cancelAction?()
                        }
                    } label: {
                        Text(cancelButtonText)
                    }
                }
                
                if !hideConfirmButton {
                    
                    Button(role: confirmButtonRole) {
                        if let _ = confirmAction {
                            confirmAction?()
                        }
                    } label: {
                        Text(confirmButtonText)
                    }
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
        
        cancelAction: (() -> Void)? = nil,
        cancelButtonText: String = "Cancel",
        cancelButtonRole: ButtonRole = .cancel,
        hideCancelButton: Bool = false,
        
        confirmAction: (() -> Void)? = nil,
        confirmButtonText: String = "Confirm",
        confirmButtonRole: ButtonRole? = nil,
        hideConfirmButton: Bool = false
        
    ) -> some View {
        self.modifier(
            AlertComponent(
                isPresented: isPresented,
                title: title,
                message: message,
                
                cancelAction: cancelAction,
                cancelButtonText: cancelButtonText,
                cancelButtonRole: cancelButtonRole,
                hideCancelButton: hideCancelButton,
                
                confirmAction: confirmAction,
                confirmButtonText: confirmButtonText,
                confirmButtonRole: confirmButtonRole,
                hideConfirmButton: hideConfirmButton
            )
        )
    }
}

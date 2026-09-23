//
//  ActionErrorAlert.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import SwiftUI

extension View {
    func actionErrorAlert(_ message: String?, onDismiss: @escaping () -> Void) -> some View {
        alert(
            "No se pudo completar la acción",
            isPresented: Binding(
                get: { message != nil },
                set: { if !$0 { onDismiss() } }
            ),
            presenting: message
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
    }
}

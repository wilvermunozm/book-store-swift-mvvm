//
//  CartItemRow.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import SwiftUI

struct CartItemRow : View {
    let item : CartItem
    let onIncrease : () async -> Void
    let onDecrease : () async -> Void

    var body: some View {
        HStack(spacing: 12) {
            BookCoverView(url: item.book.coverURL)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.book.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(item.book.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                stepper
            }

            Spacer(minLength: 8)

            Text(item.subtotal, format: .currency(code: "USD"))
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
        }
    }

    private var stepper : some View {
        HStack(spacing: 16) {
            Button {
                Task { await onDecrease() }
            } label: {
                Image(systemName: "minus.circle")
            }
            .accessibilityLabel("Quitar una unidad")

            Text("\(item.quantity)")
                .font(.subheadline.weight(.medium))
                .monospacedDigit()
                .frame(minWidth: 20)

            Button {
                Task { await onIncrease() }
            } label: {
                Image(systemName: "plus.circle")
            }
            .accessibilityLabel("Anadir una unidad")
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.tint)
    }
}

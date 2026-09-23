//
//  DetailScreen.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import SwiftUI

struct DetailScreen : View {
    let book : Book
    let isFavorite : Bool
    let onToggleFavorite : () async -> Void
    let onAddToCart : (() async -> Void)?

    @State private var didAddToCart = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                BookCoverView(url: book.coverURL, width: 180, height: 270)

                Text(book.title)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)

                if !book.authorName.isEmpty {
                    Text(book.authorName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(book.price, format: .currency(code: "USD"))
                    .font(.title3.weight(.semibold))
                    .monospacedDigit()

                if onAddToCart != nil {
                    addToCartButton
                }
            }.padding()
        }.navigationTitle(book.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    FavoriteButton(isFavorite: isFavorite) {
                        Task { await onToggleFavorite() }
                    }
                }
            }
    }

    private var addToCartButton : some View {
        Button {
            Task { await addToCart() }
        } label: {
            Label(
                didAddToCart ? "Agregado al carrito" : "Agregar al carrito",
                systemImage: didAddToCart ? "checkmark.circle.fill" : "cart.badge.plus"
            )
            .frame(maxWidth: .infinity)
            .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(didAddToCart ? .green : .accentColor)
        .disabled(didAddToCart)
        .sensoryFeedback(.success, trigger: didAddToCart)
    }

    private func addToCart() async {
        await onAddToCart?()

        withAnimation { didAddToCart = true }
        try? await Task.sleep(for: .seconds(1.2))
        withAnimation { didAddToCart = false }
    }
}

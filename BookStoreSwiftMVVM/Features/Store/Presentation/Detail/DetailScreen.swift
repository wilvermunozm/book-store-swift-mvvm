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
}

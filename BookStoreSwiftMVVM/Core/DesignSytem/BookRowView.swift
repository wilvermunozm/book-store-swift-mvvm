//
//  BookRowView.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import SwiftUI

struct BookRowView : View {
    let book : Book
    var isFavorite : Bool = false

    var body: some View {
        HStack(spacing: 12) {
            BookCoverView(url: book.coverURL)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)

                if !book.authorName.isEmpty {
                    Text(book.authorName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            if isFavorite {
                Spacer(minLength: 8)

                Image(systemName: "heart.fill")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityLabel("Favorito")
            }
        }
    }
}

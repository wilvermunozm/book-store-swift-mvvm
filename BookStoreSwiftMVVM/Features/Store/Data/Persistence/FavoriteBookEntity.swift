//
//  FavoriteBookEntity.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteBookEntity {
    @Attribute(.unique) var id: String
    var title: String
    var authorName: String
    var coverURL: URL?
    var savedAt: Date

    init(id: String, title: String, authorName: String, coverURL: URL?, savedAt: Date = .now) {
        self.id = id
        self.title = title
        self.authorName = authorName
        self.coverURL = coverURL
        self.savedAt = savedAt
    }
}

extension FavoriteBookEntity {
    convenience init(book: Book) {
        self.init(
            id: book.id,
            title: book.title,
            authorName: book.authorName,
            coverURL: book.coverURL
        )
    }

    func toBook() -> Book {
        Book(
            id: id,
            title: title,
            authorName: authorName,
            coverURL: coverURL,
            price: BookPricing.price(for: id)
        )
    }
}

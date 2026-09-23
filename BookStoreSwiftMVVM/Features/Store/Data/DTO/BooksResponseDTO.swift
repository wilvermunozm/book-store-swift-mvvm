//
//  BooksResponseApi.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 21/09/26.
//

import Foundation

struct BookDTO : Decodable {
    let key: String
    let title: String
    let author_name: [String]?
    let cover_i : Int?
}

struct BooksResponseDTO : Decodable {
    let docs : [BookDTO]
}

extension BookDTO {
    enum CoverSize: String {
        case small = "S"
        case medium = "M"
        case large = "L"
    }

    func coverURL(_ size: CoverSize = .medium) -> URL? {
        guard let cover_i else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(cover_i)-\(size.rawValue).jpg")
    }
}

extension BooksResponseDTO {
    func toBooks() -> [Book] {
        return docs.map {
            Book(
                id: $0.key,
                title: $0.title,
                authorName: $0.author_name?.first ?? "",
                coverURL: $0.coverURL(),
                price: BookPricing.price(for: $0.key)
            )
        }
    }
}

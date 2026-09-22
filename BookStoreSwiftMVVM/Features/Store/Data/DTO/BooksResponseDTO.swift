//
//  BooksResponseApi.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 21/09/26.
//

struct BookDTO : Decodable {
    let cover_i : Int
    let author_name: [String]?
}

struct BooksResponseDTO : Decodable {
    let docs : [BookDTO]
}

extension BooksResponseDTO {
    func toBooks() -> [Book] {
        return docs.map {
            Book(
                id: $0.cover_i,
                authorName: $0.author_name?.first ?? ""
            )
        }
    }
}

//
//  BookRepository.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import Foundation
import BookStoreNetworking

struct BookRepository : BookRepositoryType {
    private let restService: RestService
    private static let booksURL = URL(string: "https://openlibrary.org/search.json?q=subject:fiction&limit=20&fields=key,title,author_name,cover_i")!

    init(restService: RestService) {
        self.restService = restService
    }

    func getBooks() async throws -> [Book] {
        let response: BooksResponseDTO = try await restService.get(Self.booksURL)
        return response.toBooks()
    }
}


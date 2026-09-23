//
//  ToggleFavoriteUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

struct ToggleFavoriteUseCase {
    private let repository : FavoritesRepositoryType

    init(repository: FavoritesRepositoryType) {
        self.repository = repository
    }

    func execute(_ book: Book) async throws {
        let ids = try await repository.getFavoriteIds()

        if ids.contains(book.id) {
            try await repository.remove(id: book.id)
        } else {
            try await repository.add(book)
        }
    }
}

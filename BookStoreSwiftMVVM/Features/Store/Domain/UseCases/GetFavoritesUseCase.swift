//
//  GetFavoritesUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

struct GetFavoritesUseCase {
    private let repository : FavoritesRepositoryType

    init(repository: FavoritesRepositoryType) {
        self.repository = repository
    }

    func execute() async throws -> [Book] {
        try await repository.getFavorites()
    }
}

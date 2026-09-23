//
//  GetFavoriteIdsUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

struct GetFavoriteIdsUseCase {
    private let repository : FavoritesRepositoryType

    init(repository: FavoritesRepositoryType) {
        self.repository = repository
    }

    func execute() async throws -> Set<String> {
        try await repository.getFavoriteIds()
    }
}

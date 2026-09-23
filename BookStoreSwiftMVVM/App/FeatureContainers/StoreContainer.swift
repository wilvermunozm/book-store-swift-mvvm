//
//  StoreContainer.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

struct StoreContainer {
    private let repository: BookRepositoryType
    private let favoritesRepository: FavoritesRepositoryType

    init(repository: BookRepositoryType, favoritesRepository: FavoritesRepositoryType) {
        self.repository = repository
        self.favoritesRepository = favoritesRepository
    }

    private var getBooksUseCase : GetBooksUseCase {
        GetBooksUseCase(repository: repository)
    }

    private var getFavoritesUseCase : GetFavoritesUseCase {
        GetFavoritesUseCase(repository: favoritesRepository)
    }

    private var getFavoriteIdsUseCase : GetFavoriteIdsUseCase {
        GetFavoriteIdsUseCase(repository: favoritesRepository)
    }

    private var toggleFavoriteUseCase : ToggleFavoriteUseCase {
        ToggleFavoriteUseCase(repository: favoritesRepository)
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            getBooksUseCase: getBooksUseCase,
            getFavoriteIdsUseCase: getFavoriteIdsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }
}

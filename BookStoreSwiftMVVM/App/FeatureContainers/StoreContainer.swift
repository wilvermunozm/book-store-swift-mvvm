//
//  StoreContainer.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

struct StoreContainer {
    private let repository: BookRepositoryType
    private let favoritesRepository: FavoritesRepositoryType
    private let cartRepository: CartRepositoryType

    init(
        repository: BookRepositoryType,
        favoritesRepository: FavoritesRepositoryType,
        cartRepository: CartRepositoryType
    ) {
        self.repository = repository
        self.favoritesRepository = favoritesRepository
        self.cartRepository = cartRepository
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

    private var getCartUseCase : GetCartUseCase {
        GetCartUseCase(repository: cartRepository)
    }

    private var addToCartUseCase : AddToCartUseCase {
        AddToCartUseCase(repository: cartRepository)
    }

    private var updateCartItemUseCase : UpdateCartItemUseCase {
        UpdateCartItemUseCase(repository: cartRepository)
    }

    private var clearCartUseCase : ClearCartUseCase {
        ClearCartUseCase(repository: cartRepository)
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            getBooksUseCase: getBooksUseCase,
            getFavoriteIdsUseCase: getFavoriteIdsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            addToCartUseCase: addToCartUseCase
        )
    }

    func makeCartViewModel() -> CartViewModel {
        CartViewModel(
            getCartUseCase: getCartUseCase,
            updateCartItemUseCase: updateCartItemUseCase,
            clearCartUseCase: clearCartUseCase
        )
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }
}

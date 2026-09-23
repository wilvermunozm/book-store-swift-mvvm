//
//  FavoritesViewModel.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Observation
import Foundation

@Observable
final class FavoritesViewModel {
    private(set) var state : BookListState = .loading

    private(set) var actionError : String?

    private let getFavoritesUseCase : GetFavoritesUseCase
    private let toggleFavoriteUseCase : ToggleFavoriteUseCase

    init(
        getFavoritesUseCase: GetFavoritesUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase
    ) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func getFavorites() async {
        do {
            let bookList = try await getFavoritesUseCase.execute()

            state = if bookList.isEmpty {
                .empty
            } else {
                .loaded(bookList)
            }
        } catch {
            state = .error("Failed to load favorites: \(error.localizedDescription)")
        }
    }

    func removeFavorite(_ book: Book) async {
        do {
            try await toggleFavoriteUseCase.execute(book)
            await getFavorites()
        } catch {
            actionError = "No se pudo quitar de favoritos: \(error.localizedDescription)"
        }
    }

    func dismissActionError() {
        actionError = nil
    }
}

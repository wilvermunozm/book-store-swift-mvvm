//
//  HomeViewModel.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import Observation
import Foundation

@Observable
final class HomeViewModel {
    private(set) var state : BookListState = .loading
    private(set) var favoriteIds : Set<String> = []

    private let getBooksUseCase : GetBooksUseCase
    private let getFavoriteIdsUseCase : GetFavoriteIdsUseCase
    private let toggleFavoriteUseCase : ToggleFavoriteUseCase

    init(
        getBooksUseCase: GetBooksUseCase,
        getFavoriteIdsUseCase: GetFavoriteIdsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase
    ) {
        self.getBooksUseCase = getBooksUseCase
        self.getFavoriteIdsUseCase = getFavoriteIdsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func getBooks() async {
        await refreshFavorites()

        do {
            let bookList = try await getBooksUseCase.execute()

            state = if bookList.isEmpty {
                .empty
            } else {
                .loaded(bookList)
            }
        } catch {
            state = .error("Failed to load books: \(error.localizedDescription)")
        }
    }

    func isFavorite(_ book: Book) -> Bool {
        favoriteIds.contains(book.id)
    }

    func toggleFavorite(_ book: Book) async {
        do {
            try await toggleFavoriteUseCase.execute(book)
            await refreshFavorites()
        } catch {
            state = .error("Failed to update favorites: \(error.localizedDescription)")
        }
    }

    
    func refreshFavorites() async {
        favoriteIds = (try? await getFavoriteIdsUseCase.execute()) ?? []
    }
}

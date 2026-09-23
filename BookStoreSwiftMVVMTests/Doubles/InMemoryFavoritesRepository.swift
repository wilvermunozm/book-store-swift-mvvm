//
//  InMemoryFavoritesRepository.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

@testable import BookStoreSwiftMVVM

final class InMemoryFavoritesRepository : FavoritesRepositoryType {
    private var storage: [String: Book]

    init(books: [Book] = []) {
        self.storage = Dictionary(uniqueKeysWithValues: books.map { ($0.id, $0) })
    }

    func getFavorites() async throws -> [Book] {
        Array(storage.values)
    }

    func getFavoriteIds() async throws -> Set<String> {
        Set(storage.keys)
    }

    func add(_ book: Book) async throws {
        storage[book.id] = book
    }

    func remove(id: String) async throws {
        storage[id] = nil
    }
}

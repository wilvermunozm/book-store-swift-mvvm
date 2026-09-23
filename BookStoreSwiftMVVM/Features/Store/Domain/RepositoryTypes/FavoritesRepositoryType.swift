//
//  FavoritesRepositoryType.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

protocol FavoritesRepositoryType {
    func getFavorites() async throws -> [Book]
    func getFavoriteIds() async throws -> Set<String>
    func add(_ book: Book) async throws
    func remove(id: String) async throws
}

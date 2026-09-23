//
//  FavoritesRepository.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Foundation
import SwiftData

struct FavoritesRepository : FavoritesRepositoryType {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getFavorites() async throws -> [Book] {
        let descriptor = FetchDescriptor<FavoriteBookEntity>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map { $0.toBook() }
    }

    func getFavoriteIds() async throws -> Set<String> {
        let descriptor = FetchDescriptor<FavoriteBookEntity>()
        return Set(try context.fetch(descriptor).map(\.id))
    }

    func add(_ book: Book) async throws {
        context.insert(FavoriteBookEntity(book: book))
        try context.save()
    }

    func remove(id: String) async throws {
        let descriptor = FetchDescriptor<FavoriteBookEntity>(
            predicate: #Predicate { $0.id == id }
        )
        for entity in try context.fetch(descriptor) {
            context.delete(entity)
        }
        try context.save()
    }
}

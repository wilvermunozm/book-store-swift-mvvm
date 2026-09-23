//
//  UpdateCartItemUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

struct UpdateCartItemUseCase {
    private let repository : CartRepositoryType

    init(repository: CartRepositoryType) {
        self.repository = repository
    }

    func increase(_ book: Book) async throws {
        try await repository.add(book)
    }

    func decrease(_ item: CartItem) async throws {
        try await repository.decrease(id: item.id)
    }

    func remove(_ item: CartItem) async throws {
        try await repository.remove(id: item.id)
    }
}

//
//  AddToCartUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

struct AddToCartUseCase {
    private let repository : CartRepositoryType

    init(repository: CartRepositoryType) {
        self.repository = repository
    }

    func execute(_ book: Book) async throws {
        try await repository.add(book)
    }
}

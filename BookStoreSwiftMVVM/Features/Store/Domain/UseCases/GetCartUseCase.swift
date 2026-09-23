//
//  GetCartUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

struct GetCartUseCase {
    private let repository : CartRepositoryType

    init(repository: CartRepositoryType) {
        self.repository = repository
    }

    func execute() async throws -> [CartItem] {
        try await repository.getItems()
    }
}

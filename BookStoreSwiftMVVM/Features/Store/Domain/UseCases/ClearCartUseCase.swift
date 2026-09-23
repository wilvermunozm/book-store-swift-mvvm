//
//  ClearCartUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

struct ClearCartUseCase {
    private let repository : CartRepositoryType

    init(repository: CartRepositoryType) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.clear()
    }
}

//
//  GetBooksUseCase.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

struct GetBooksUseCase {
    private let repository : BookRepositoryType
    
    init(repository: BookRepositoryType) {
        self.repository = repository
    }
    
    func getBooks() async throws -> [Book]{
        try await  repository.getBooks()
    }
}

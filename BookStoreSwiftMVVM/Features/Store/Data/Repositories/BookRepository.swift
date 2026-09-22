//
//  BookRepository.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

struct BookRepository : BookRepositoryType {
    private let restService : RestService
    
    init(restService: RestService) {
        self.restService = restService
    }
    
    func getBooks() async throws -> [Book]{
        try await restService.get()
    }
}


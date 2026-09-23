//
//  StubBookRepository.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

@testable import BookStoreSwiftMVVM

struct StubBookRepository : BookRepositoryType {
    var result: Result<[Book], Error>
    
    init(result: Result<[Book], Error> = .success([])) {
        self.result = result
    }
    
    func getBooks() async throws -> [Book] {
        try result.get()
    }
}

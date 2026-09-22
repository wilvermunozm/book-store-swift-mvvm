//
//  BookRepositoryType.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

protocol BookRepositoryType {
    func getBooks() async throws -> [Book]
}

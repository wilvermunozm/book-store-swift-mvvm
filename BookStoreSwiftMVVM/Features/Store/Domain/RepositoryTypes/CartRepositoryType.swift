//
//  CartRepositoryType.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

protocol CartRepositoryType {
    func getItems() async throws -> [CartItem]
    func add(_ book: Book) async throws
    func decrease(id: String) async throws
    func remove(id: String) async throws
    func clear() async throws
}

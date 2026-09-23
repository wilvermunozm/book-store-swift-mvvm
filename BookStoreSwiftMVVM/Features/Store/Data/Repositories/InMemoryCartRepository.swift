//
//  InMemoryCartRepository.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Foundation

final class InMemoryCartRepository : CartRepositoryType {
    private var books: [String: Book] = [:]
    private var quantities: [String: Int] = [:]
    private var order: [String] = []

    func getItems() async throws -> [CartItem] {
        order.compactMap { id in
            guard let book = books[id], let quantity = quantities[id] else { return nil }
            return CartItem(book: book, quantity: quantity)
        }
    }

    func add(_ book: Book) async throws {
        if quantities[book.id] == nil {
            order.append(book.id)
            books[book.id] = book
        }
        quantities[book.id, default: 0] += 1
    }

    func decrease(id: String) async throws {
        guard let quantity = quantities[id] else { return }

        if quantity <= 1 {
            try await remove(id: id)
        } else {
            quantities[id] = quantity - 1
        }
    }

    func remove(id: String) async throws {
        books[id] = nil
        quantities[id] = nil
        order.removeAll { $0 == id }
    }

    func clear() async throws {
        books.removeAll()
        quantities.removeAll()
        order.removeAll()
    }
}

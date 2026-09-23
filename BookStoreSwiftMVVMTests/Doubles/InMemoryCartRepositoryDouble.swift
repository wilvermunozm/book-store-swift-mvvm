//
//  InMemoryCartRepositoryDouble.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

@testable import BookStoreSwiftMVVM

final class StubCartRepository : CartRepositoryType {
    private(set) var items: [CartItem] = []

    func getItems() async throws -> [CartItem] { items }

    func add(_ book: Book) async throws {
        if let index = items.firstIndex(where: { $0.id == book.id }) {
            items[index] = CartItem(book: book, quantity: items[index].quantity + 1)
        } else {
            items.append(CartItem(book: book, quantity: 1))
        }
    }

    func decrease(id: String) async throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        let item = items[index]
        if item.quantity <= 1 {
            items.remove(at: index)
        } else {
            items[index] = CartItem(book: item.book, quantity: item.quantity - 1)
        }
    }

    func remove(id: String) async throws {
        items.removeAll { $0.id == id }
    }

    func clear() async throws {
        items.removeAll()
    }
}

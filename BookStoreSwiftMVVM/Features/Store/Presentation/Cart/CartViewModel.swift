//
//  CartViewModel.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Observation
import Foundation

enum CartState : Equatable {
    case loading
    case error(String)
    case loaded([CartItem])
    case empty
}

@Observable
final class CartViewModel {
    private(set) var state : CartState = .loading

    private let getCartUseCase : GetCartUseCase
    private let updateCartItemUseCase : UpdateCartItemUseCase
    private let clearCartUseCase : ClearCartUseCase

    init(
        getCartUseCase: GetCartUseCase,
        updateCartItemUseCase: UpdateCartItemUseCase,
        clearCartUseCase: ClearCartUseCase
    ) {
        self.getCartUseCase = getCartUseCase
        self.updateCartItemUseCase = updateCartItemUseCase
        self.clearCartUseCase = clearCartUseCase
    }

    var items : [CartItem] {
        if case .loaded(let items) = state { return items }
        return []
    }

    var total : Decimal {
        items.total
    }

    func getCart() async {
        do {
            let items = try await getCartUseCase.execute()

            state = if items.isEmpty {
                .empty
            } else {
                .loaded(items)
            }
        } catch {
            state = .error("Failed to load cart: \(error.localizedDescription)")
        }
    }

    func increase(_ item: CartItem) async {
        await mutate { try await updateCartItemUseCase.increase(item.book) }
    }

    func decrease(_ item: CartItem) async {
        await mutate { try await updateCartItemUseCase.decrease(item) }
    }

    func remove(_ item: CartItem) async {
        await mutate { try await updateCartItemUseCase.remove(item) }
    }

    func clear() async {
        await mutate { try await clearCartUseCase.execute() }
    }

    private func mutate(_ operation: () async throws -> Void) async {
        do {
            try await operation()
            await getCart()
        } catch {
            state = .error("Failed to update cart: \(error.localizedDescription)")
        }
    }
}

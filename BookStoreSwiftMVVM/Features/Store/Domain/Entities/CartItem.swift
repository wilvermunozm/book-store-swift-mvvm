//
//  CartItem.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Foundation

struct CartItem : Identifiable, Hashable {
    let book: Book
    let quantity: Int

    var id: String { book.id }

    var subtotal: Decimal {
        book.price * Decimal(quantity)
    }
}

extension Array where Element == CartItem {
    var total: Decimal {
        reduce(0) { $0 + $1.subtotal }
    }

    var unitCount: Int {
        reduce(0) { $0 + $1.quantity }
    }
}

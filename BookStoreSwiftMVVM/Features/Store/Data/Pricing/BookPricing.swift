//
//  BookPricing.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Foundation

enum BookPricing {

    static func price(for key: String) -> Decimal {
        let hash = key.unicodeScalars.reduce(into: 0) { acc, scalar in
            acc = (acc &* 31 &+ Int(scalar.value)) & 0x00FF_FFFF
        }
        let whole = 4 + (hash % 30)
        return Decimal(whole) + Decimal(0.99)
    }
}

//
//  FavoriteButton.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import SwiftUI

struct FavoriteButton : View {
    let isFavorite : Bool
    let action : () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? .red : .secondary)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
    }
}

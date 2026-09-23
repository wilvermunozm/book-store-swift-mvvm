//
//  BookStoreSwiftMVVMApp.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 21/09/26.
//

import SwiftUI

@main
struct BookStoreSwiftMVVMApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Libros", systemImage: "books.vertical") {
                    HomeScreen(viewModel: container.store.makeHomeViewModel())
                }

                Tab("Favoritos", systemImage: "heart") {
                    FavoritesScreen(viewModel: container.store.makeFavoritesViewModel())
                }
            }
        }
    }
}

//
//  FavoritesScreen.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import SwiftUI

struct FavoritesScreen : View {
    @State var viewModel : FavoritesViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Favoritos")
                .navigationDestination(for: Book.self){ book in
                    DetailScreen(
                        book: book,
                        isFavorite: true,
                        onToggleFavorite: { await viewModel.removeFavorite(book) },
                        onAddToCart: nil
                    )
                }
        }.task {
            await viewModel.getFavorites()
        }
    }

    @ViewBuilder
    private var content : some View {
        switch viewModel.state {
        case .loading : LoaderView()
        case .error(let errorMessage): ErrorView(errorMenssage: errorMessage)
        case .empty: EmptyStateView()
        case .loaded(let bookList) :
            List(bookList){ book in
                NavigationLink(value: book){
                    BookRowView(book: book)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task { await viewModel.removeFavorite(book) }
                    } label: {
                        Label("Quitar", systemImage: "heart.slash")
                    }
                }
            }
        }
    }
}

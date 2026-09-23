//
//  HomeScreen.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//
import SwiftUI

struct HomeScreen : View {
    @State var viewModel : HomeViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Book Store")
                .navigationDestination(for: Book.self){ book in
                    DetailScreen(
                        book: book,
                        isFavorite: viewModel.isFavorite(book),
                        onToggleFavorite: { await viewModel.toggleFavorite(book) },
                        onAddToCart: { await viewModel.addToCart(book) }
                    )
                }
        }.task {
            await viewModel.getBooks()
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
                    BookRowView(book: book, isFavorite: viewModel.isFavorite(book))
                }
                .swipeActions(edge: .leading) {
                    Button {
                        Task { await viewModel.addToCart(book) }
                    } label: {
                        Label("Al carrito", systemImage: "cart.badge.plus")
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        Task { await viewModel.toggleFavorite(book) }
                    } label: {
                        Label(
                            viewModel.isFavorite(book) ? "Quitar" : "Favorito",
                            systemImage: viewModel.isFavorite(book) ? "heart.slash" : "heart"
                        )
                    }
                    .tint(.red)
                }
            }
        }
    }
}

#Preview {
    let container = AppContainer()
    HomeScreen(viewModel: container.store.makeHomeViewModel())
}

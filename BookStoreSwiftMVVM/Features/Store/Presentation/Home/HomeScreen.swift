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
                    DetailScreen(book: book)
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
                    row(for: book)
                }
            }
        }
    }

    @ViewBuilder
    private func row(for book: Book) -> some View {
        HStack(spacing: 12) {
            BookCoverView(url: book.coverURL)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)

                if !book.authorName.isEmpty {
                    Text(book.authorName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    let container = AppContainer()
    HomeScreen(viewModel: container.store.makeViewModel())
}

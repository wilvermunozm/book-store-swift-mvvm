//
//  HomeScreen.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//
import SwiftUI

struct HomeScreen : View {
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        
        VStack {
            switch viewModel.state {
            case .loading : LoaderView()
            case .error(let errorMessage): ErrorView(errorMenssage: errorMessage)
            case .empty: EmptyStateView()
            case .loaded(let bookList) :
                NavigationStack {
                    List(bookList){ book in
                        NavigationLink(value: book){
                            Text(book.authorName)
                        }
                    }.navigationDestination(for: Book.self){ book in
                        DetailScreen(book: book)
                    }
                    .navigationTitle("Book Store")
                }
            }
        }.task {
            await viewModel.getBooks()
        }
        
        
    }
}

#Preview {
    HomeScreen()
}

//
//  HomeScreen.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//
import SwiftUI

struct HomeScreen : View {
    @State var bookList : [Book] = []
    
    var body: some View {
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
        .task {
            let service = RestService()
            do {
                bookList = try await service.get()
            } catch {
                print("Failed to load books: \(error)")
            }
        }
    }
}

#Preview {
    HomeScreen()
}

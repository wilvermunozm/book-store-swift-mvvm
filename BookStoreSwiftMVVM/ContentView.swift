//
//  ContentView.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 21/09/26.
//

import SwiftUI

struct ContentView: View {
    @State var bookList : [Book] = []
    
    var body: some View {
        List(bookList){ book in
            Text(book.authorName)
        }
        .padding()
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
    ContentView()
}

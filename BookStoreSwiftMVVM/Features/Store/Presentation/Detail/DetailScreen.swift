//
//  DetailScreen.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import SwiftUI

struct DetailScreen : View {
    let book : Book
    
    var body: some View {
        VStack{
            Text(book.authorName)
        }.navigationTitle("Book \(book.title)")
    }
}

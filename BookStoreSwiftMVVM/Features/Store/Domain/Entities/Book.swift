//
//  Book.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 21/09/26.
//

import Foundation

struct Book : Identifiable, Hashable {
    let id: String
    let title: String
    let authorName : String
    let coverURL: URL?
}

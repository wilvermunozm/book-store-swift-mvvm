//
//  BookListState.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

enum BookListState : Equatable {
    case loading
    case error(String)
    case loaded([Book])
    case empty
}

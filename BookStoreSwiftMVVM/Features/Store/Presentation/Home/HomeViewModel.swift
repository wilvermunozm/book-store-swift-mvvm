//
//  HomeViewModel.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import Observation
import Foundation

@Observable
final class HomeViewModel {
    private(set) var state : HomeState = .loading
    private let getBooksUseCase : GetBooksUseCase
    
    init(getBooksUseCase: GetBooksUseCase) {
        self.getBooksUseCase = getBooksUseCase
    }
    
    func getBooks() async {
        do {
            let bookList = try await getBooksUseCase.execute()
            
            state = if bookList.isEmpty {
                .empty
            } else {
                .loaded(bookList)
            }
        } catch {
            state = .error("Failed to load books: \(error.localizedDescription)")
        }
    }
}

enum HomeState {
    case loading
    case error(String)
    case loaded([Book])
    case empty
}

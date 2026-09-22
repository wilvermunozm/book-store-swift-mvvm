//
//  StoreContainer.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

struct StoreContainer {
    private let repository: BookRepositoryType
    
    init(repository: BookRepositoryType) {
        self.repository = repository
    }
    
    private var getBooksUseCase : GetBooksUseCase {
        GetBooksUseCase(repository: repository)
    }
    
    func makeViewModel() -> HomeViewModel {
        HomeViewModel(getBooksUseCase: getBooksUseCase)
    }
}

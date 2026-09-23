//
//  AppContainer.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import BookStoreNetworking

final class AppContainer {
    
    let store: StoreContainer
    
    init() {
        let restService = RestService()
        self.store = StoreContainer(
            repository: BookRepository(restService: restService)
        )
    }
}

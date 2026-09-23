//
//  AppContainer.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import SwiftData
import BookStoreNetworking

final class AppContainer {
    
    let store: StoreContainer
    private let modelContainer: ModelContainer
    
    init() {
        let restService = RestService()
        
        self.modelContainer = try! ModelContainer(for: FavoriteBookEntity.self)
        
        self.store = StoreContainer(
            repository: BookRepository(restService: restService),
            favoritesRepository: FavoritesRepository(context: modelContainer.mainContext)
        )
    }
}

//
//  BookStoreSwiftMVVMApp.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 21/09/26.
//

import SwiftUI

@main
struct BookStoreSwiftMVVMApp: App {
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            HomeScreen(
                viewModel: container.store.makeViewModel()
            )
        }
    }
}

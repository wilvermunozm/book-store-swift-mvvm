//
//  HomeViewModelTests.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import Testing
@testable import BookStoreSwiftMVVM

@MainActor
struct HomeViewModelTests {
    
    private func makeVM(_ result: Result<[Book], Error>) -> HomeViewModel {
        HomeViewModel(
            getBooksUseCase: GetBooksUseCase(
                repository: StubBookRepository(result: result)
            )
        )
    }
    
    @Test func startsInLoadingState() {
        let sut = makeVM(.success([]))
        #expect(sut.state == .loading)
    }
    
    @Test func showsBooksWhenRepositoryReturnsData() async {
        let books = [Book(id: 1, authorName: "Borges")]
        let sut = makeVM(.success(books))
        await sut.getBooks()
        #expect(sut.state == .loaded(books))
    }
    
    @Test func showsEmptyWhenRepositoryReturnsNoBooks() async {
        let sut = makeVM(.success([]))
        await sut.getBooks()
        #expect(sut.state == .empty)
    }
    
    @Test func showsErrorWhenRepositoryFails() async {
        let sut = makeVM(.failure(ApiError.badResponse(500)))
        await sut.getBooks()
        #expect(sut.state.isError)
    }
}

private extension HomeState {
    var isError: Bool {
        if case .error = self { return true }
        return false
    }
}

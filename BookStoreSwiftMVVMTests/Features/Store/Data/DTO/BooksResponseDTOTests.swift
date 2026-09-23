//
//  BooksResponseDTOTests.swift
//  BookStoreSwiftMVVMTests
//
//  Created by Wilver Muñoz on 23/09/26.
//

import Testing
import Foundation
@testable import BookStoreSwiftMVVM

struct BooksResponseDTOTests {

    private func decode(_ json: String) throws -> [Book] {
        try JSONDecoder()
            .decode(BooksResponseDTO.self, from: Data(json.utf8))
            .toBooks()
    }

    // MARK: - Mapeo de campos

    @Test func mapsKeyAsBookIdentifier() throws {
        let books = try decode("""
        {"docs":[{"key":"/works/OL123W","title":"Ficciones","author_name":["Borges"],"cover_i":7}]}
        """)

        #expect(books.count == 1)
        #expect(books[0].id == "/works/OL123W")
        #expect(books[0].title == "Ficciones")
    }

    @Test func takesFirstAuthorWhenSeveralAreReturned() throws {
        let books = try decode("""
        {"docs":[{"key":"/works/OL1W","title":"T","author_name":["Borges","Bioy Casares"]}]}
        """)

        #expect(books[0].authorName == "Borges")
    }

    @Test func authorIsEmptyWhenMissing() throws {
        let books = try decode("""
        {"docs":[{"key":"/works/OL1W","title":"T"}]}
        """)

        #expect(books[0].authorName == "")
    }

    // MARK: - Portada

    @Test func buildsCoverURLFromCoverIdentifier() throws {
        let books = try decode("""
        {"docs":[{"key":"/works/OL1W","title":"T","cover_i":7}]}
        """)

        #expect(books[0].coverURL == URL(string: "https://covers.openlibrary.org/b/id/7-M.jpg"))
    }

    @Test func coverURLIsNilWhenCoverIsMissing() throws {
        let books = try decode("""
        {"docs":[{"key":"/works/OL1W","title":"T"}]}
        """)

        #expect(books[0].coverURL == nil)
    }

    @Test func decodesWholeListWhenSomeBooksHaveNoCover() throws {
        let books = try decode("""
        {"docs":[
          {"key":"/works/OL1W","title":"Con portada","cover_i":7},
          {"key":"/works/OL2W","title":"Sin portada"}
        ]}
        """)

        #expect(books.count == 2)
        #expect(books[0].coverURL != nil)
        #expect(books[1].coverURL == nil)
    }

    @Test func buildsCoverURLForRequestedSize() {
        let dto = BookDTO(key: "/works/OL1W", title: "T", author_name: nil, cover_i: 7)

        #expect(dto.coverURL(.large) == URL(string: "https://covers.openlibrary.org/b/id/7-L.jpg"))
        #expect(dto.coverURL(.small) == URL(string: "https://covers.openlibrary.org/b/id/7-S.jpg"))
    }

    // MARK: - Contrato obligatorio

    @Test func failsWhenKeyIsMissing() {
        #expect(throws: DecodingError.self) {
            try decode("""
            {"docs":[{"title":"T","cover_i":7}]}
            """)
        }
    }

    @Test func returnsEmptyListWhenThereAreNoDocs() throws {
        let books = try decode("""
        {"docs":[]}
        """)

        #expect(books.isEmpty)
    }
}

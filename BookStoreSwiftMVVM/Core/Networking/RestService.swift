//
//  RestService.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//
import Foundation


enum ApiError : Error {
    case badResponse(Int)
}

struct RestService {
    
    func get() async throws -> [Book] {
        let (data,response) = try await URLSession.shared.data(from: URL(string: "https://openlibrary.org/search.json?q=subject:fiction&limit=20&fields=key,title,author_name,cover_i,first_publish_year")!)
        guard let http = response as? HTTPURLResponse, (200...209).contains(http.statusCode) else {
            throw ApiError.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return try JSONDecoder().decode(BooksResponseDTO.self, from: data).toBooks()
    }
    
}


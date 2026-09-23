import Foundation

public enum ApiError: Error {
    case badResponse(Int)
}

public struct RestService {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw ApiError.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

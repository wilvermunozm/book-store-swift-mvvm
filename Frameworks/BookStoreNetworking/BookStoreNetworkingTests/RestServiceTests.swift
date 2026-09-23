import Testing
import Foundation
@testable import BookStoreNetworking

@Suite(.serialized)
struct RestServiceTests {

    private let url = URL(string: "https://example.com/books")!

    private struct Payload: Decodable, Equatable {
        let id: Int
        let title: String
    }

    private func makeSUT() -> RestService {
        RestService(session: MockURLProtocol.makeSession())
    }

    @Test func decodesResponseBody() async throws {
        MockURLProtocol.respond(body: #"{"id":7,"title":"Ficciones"}"#)
        defer { MockURLProtocol.reset() }

        let payload: Payload = try await makeSUT().get(url)

        #expect(payload == Payload(id: 7, title: "Ficciones"))
    }

    @Test(arguments: [200, 201, 204, 299])
    func acceptsAnySuccessStatusCode(code: Int) async throws {
        MockURLProtocol.respond(statusCode: code, body: #"{"id":1,"title":"T"}"#)
        defer { MockURLProtocol.reset() }

        let payload: Payload = try await makeSUT().get(url)

        #expect(payload.id == 1)
    }

    @Test(arguments: [400, 401, 404, 500, 503])
    func throwsBadResponseOutsideSuccessRange(code: Int) async {
        MockURLProtocol.respond(statusCode: code, body: "{}")
        defer { MockURLProtocol.reset() }

        await #expect(throws: ApiError.self) {
            let _: Payload = try await makeSUT().get(url)
        }
    }

    @Test func badResponseCarriesTheStatusCode() async {
        MockURLProtocol.respond(statusCode: 503, body: "{}")
        defer { MockURLProtocol.reset() }

        do {
            let _: Payload = try await makeSUT().get(url)
            Issue.record("Se esperaba un error")
        } catch let error as ApiError {
            guard case .badResponse(let code) = error else {
                Issue.record("Caso de error inesperado: \(error)")
                return
            }
            #expect(code == 503)
        } catch {
            Issue.record("Tipo de error inesperado: \(error)")
        }
    }

    @Test func throwsDecodingErrorWhenBodyDoesNotMatch() async {
        MockURLProtocol.respond(body: #"{"unexpected":true}"#)
        defer { MockURLProtocol.reset() }

        await #expect(throws: DecodingError.self) {
            let _: Payload = try await makeSUT().get(url)
        }
    }

    @Test func propagatesTransportErrors() async {
        MockURLProtocol.fail(with: URLError(.notConnectedToInternet))
        defer { MockURLProtocol.reset() }

        await #expect(throws: URLError.self) {
            let _: Payload = try await makeSUT().get(url)
        }
    }
}

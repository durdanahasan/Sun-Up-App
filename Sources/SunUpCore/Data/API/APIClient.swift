import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct EmptyResponse: Codable, Sendable { public init() {} }

public final class APIClient: @unchecked Sendable {
    public let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        decoder.dateDecodingStrategy = .iso8601
        encoder.dateEncodingStrategy = .iso8601
    }

    public func request<Response: Decodable, Body: Encodable>(_ path: String, method: String = "GET", body: Body? = Optional<String>.none, response: Response.Type = Response.self) async throws -> Response {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let body {
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, urlResponse) = try await session.data(for: request)
        guard let http = urlResponse as? HTTPURLResponse else { throw ServiceError.invalidResponse }
        guard (200...299).contains(http.statusCode) else { throw ServiceError.httpStatus(http.statusCode) }
        if Response.self == EmptyResponse.self, data.isEmpty { return EmptyResponse() as! Response }
        return try decoder.decode(Response.self, from: data)
    }
}

import Foundation

private struct LoginBody: Codable { let email: String; let password: String }
private struct SignUpBody: Codable { let fullName: String; let email: String; let password: String }
private struct EmailBody: Codable { let email: String }
private struct VerifyBody: Codable { let email: String; let code: String }
private struct TokenResponse: Codable { let token: String }
private struct ResetBody: Codable { let password: String; let token: String }

public struct APIAuthService: AuthServiceProtocol {
    private let client: APIClient
    public init(client: APIClient) { self.client = client }
    public func login(email: String, password: String) async throws -> User { try await client.request("auth/login", method: "POST", body: LoginBody(email: email, password: password)) }
    public func signUp(fullName: String, email: String, password: String) async throws -> User { try await client.request("auth/signup", method: "POST", body: SignUpBody(fullName: fullName, email: email, password: password)) }
    public func requestPasswordReset(email: String) async throws { let _: EmptyResponse = try await client.request("auth/password/forgot", method: "POST", body: EmailBody(email: email)) }
    public func verifyResetCode(_ code: String, email: String) async throws -> String { let result: TokenResponse = try await client.request("auth/password/verify", method: "POST", body: VerifyBody(email: email, code: code)); return result.token }
    public func resetPassword(_ password: String, token: String) async throws { let _: EmptyResponse = try await client.request("auth/password/reset", method: "POST", body: ResetBody(password: password, token: token)) }
    public func logout() async throws { let _: EmptyResponse = try await client.request("auth/logout", method: "POST") }
}

public struct APIBeachService: BeachServiceProtocol {
    private let client: APIClient
    public init(client: APIClient) { self.client = client }
    public func fetchBeaches() async throws -> [Beach] { try await client.request("beaches") }
    public func searchBeaches(query: String) async throws -> [Beach] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        return try await client.request("beaches?search=\(encoded)")
    }
    public func fetchKits() async throws -> [Kit] { try await client.request("kits") }
}

public struct APIOrderService: OrderServiceProtocol {
    private let client: APIClient
    public init(client: APIClient) { self.client = client }
    public func fetchOrders() async throws -> [Order] { try await client.request("orders") }
    public func fetchOrder(id: UUID) async throws -> Order { try await client.request("orders/\(id.uuidString)") }
    public func createOrder(_ request: CreateOrderRequest) async throws -> Order { try await client.request("orders", method: "POST", body: request) }
}

public struct APINotificationService: NotificationServiceProtocol {
    private let client: APIClient
    public init(client: APIClient) { self.client = client }
    public func fetchNotifications() async throws -> [AppNotification] { try await client.request("notifications") }
    public func markAsRead(id: UUID) async throws { let _: EmptyResponse = try await client.request("notifications/\(id.uuidString)/read", method: "PATCH") }
}

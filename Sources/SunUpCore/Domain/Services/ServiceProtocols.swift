import Foundation

public protocol AuthServiceProtocol: Sendable {
    func login(email: String, password: String) async throws -> User
    func signUp(fullName: String, email: String, password: String) async throws -> User
    func requestPasswordReset(email: String) async throws
    func verifyResetCode(_ code: String, email: String) async throws -> String
    func resetPassword(_ password: String, token: String) async throws
    func logout() async throws
}

public protocol BeachServiceProtocol: Sendable {
    func fetchBeaches() async throws -> [Beach]
    func searchBeaches(query: String) async throws -> [Beach]
    func fetchKits() async throws -> [Kit]
}

public protocol OrderServiceProtocol: Sendable {
    func fetchOrders() async throws -> [Order]
    func fetchOrder(id: UUID) async throws -> Order
    func createOrder(_ request: CreateOrderRequest) async throws -> Order
}

public protocol NotificationServiceProtocol: Sendable {
    func fetchNotifications() async throws -> [AppNotification]
    func markAsRead(id: UUID) async throws
}

public enum ServiceError: LocalizedError, Equatable {
    case invalidCredentials
    case emailAlreadyRegistered
    case invalidVerificationCode
    case notFound
    case invalidResponse
    case httpStatus(Int)

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials: "Incorrect email or password."
        case .emailAlreadyRegistered: "An account already exists for this email."
        case .invalidVerificationCode: "The verification code is invalid."
        case .notFound: "The requested item could not be found."
        case .invalidResponse: "The server returned an invalid response."
        case .httpStatus(let code): "The request failed with status code \(code)."
        }
    }
}

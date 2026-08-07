import Foundation

public actor MockAuthService: AuthServiceProtocol {
    private var currentUser: User?
    public init() {}

    public func login(email: String, password: String) async throws -> User {
        guard email.lowercased() == MockData.user.email.lowercased(), password.count >= 6 else { throw ServiceError.invalidCredentials }
        currentUser = MockData.user
        return MockData.user
    }

    public func signUp(fullName: String, email: String, password: String) async throws -> User {
        guard email.lowercased() != MockData.user.email.lowercased() else { throw ServiceError.emailAlreadyRegistered }
        let user = User(fullName: fullName, email: email)
        currentUser = user
        return user
    }

    public func requestPasswordReset(email: String) async throws {}
    public func verifyResetCode(_ code: String, email: String) async throws -> String {
        guard code == "402456" else { throw ServiceError.invalidVerificationCode }
        return "mock-reset-token"
    }
    public func resetPassword(_ password: String, token: String) async throws {}
    public func logout() async throws { currentUser = nil }
}

public struct MockBeachService: BeachServiceProtocol {
    public init() {}
    public func fetchBeaches() async throws -> [Beach] { MockData.beaches }
    public func searchBeaches(query: String) async throws -> [Beach] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return MockData.beaches }
        return MockData.beaches.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
    public func fetchKits() async throws -> [Kit] { MockData.kits }
}

public actor MockOrderService: OrderServiceProtocol {
    private var orders: [Order]
    public init(orders: [Order] = MockData.orders) { self.orders = orders }
    public func fetchOrders() async throws -> [Order] { orders.sorted { $0.deliveryDate > $1.deliveryDate } }
    public func fetchOrder(id: UUID) async throws -> Order {
        guard let order = orders.first(where: { $0.id == id }) else { throw ServiceError.notFound }
        return order
    }
    public func createOrder(_ request: CreateOrderRequest) async throws -> Order {
        guard let beach = MockData.beaches.first(where: { $0.id == request.beachID }) else { throw ServiceError.notFound }
        let order = Order(reference: "SU-\(Int.random(in: 1000...9999))", userID: MockData.userID, beach: beach, items: request.items, status: .confirmed, deliveryDate: request.deliveryDate, phoneNumber: request.phoneNumber, note: request.note, paymentMethod: request.paymentMethod, runner: MockData.runner)
        orders.insert(order, at: 0)
        return order
    }
}

public actor MockNotificationService: NotificationServiceProtocol {
    private var notifications = MockData.notifications
    public init() {}
    public func fetchNotifications() async throws -> [AppNotification] { notifications.sorted { $0.createdAt > $1.createdAt } }
    public func markAsRead(id: UUID) async throws {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { throw ServiceError.notFound }
        notifications[index].isRead = true
    }
}

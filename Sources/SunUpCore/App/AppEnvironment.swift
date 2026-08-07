import Foundation

public enum AppEnvironment {
    /// Change this one flag for local mock data vs. REST-backed services.
    public static var useMockData = true
    public static var apiBaseURL = URL(string: "https://api.sunup.example/v1/")!
}

public struct AppDependencies: Sendable {
    public let authService: any AuthServiceProtocol
    public let beachService: any BeachServiceProtocol
    public let orderService: any OrderServiceProtocol
    public let notificationService: any NotificationServiceProtocol

    public init(authService: any AuthServiceProtocol, beachService: any BeachServiceProtocol, orderService: any OrderServiceProtocol, notificationService: any NotificationServiceProtocol) {
        self.authService = authService
        self.beachService = beachService
        self.orderService = orderService
        self.notificationService = notificationService
    }

    public static func make(useMockData: Bool = AppEnvironment.useMockData, baseURL: URL = AppEnvironment.apiBaseURL) -> Self {
        if useMockData {
            return .init(authService: MockAuthService(), beachService: MockBeachService(), orderService: MockOrderService(), notificationService: MockNotificationService())
        }
        let client = APIClient(baseURL: baseURL)
        return .init(authService: APIAuthService(client: client), beachService: APIBeachService(client: client), orderService: APIOrderService(client: client), notificationService: APINotificationService(client: client))
    }
}

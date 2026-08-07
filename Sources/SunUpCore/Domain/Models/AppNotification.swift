import Foundation

public enum NotificationKind: String, Codable, Sendable {
    case order, promotion, welcome
}

public struct AppNotification: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let kind: NotificationKind
    public let title: String
    public let message: String
    public let createdAt: Date
    public var isRead: Bool

    public init(id: UUID = UUID(), kind: NotificationKind, title: String, message: String, createdAt: Date, isRead: Bool = false) {
        self.id = id
        self.kind = kind
        self.title = title
        self.message = message
        self.createdAt = createdAt
        self.isRead = isRead
    }
}

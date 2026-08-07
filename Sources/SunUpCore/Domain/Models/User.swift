import Foundation

public struct User: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var fullName: String
    public var email: String
    public var phoneNumber: String?
    public var avatarURL: URL?

    public init(id: UUID = UUID(), fullName: String, email: String, phoneNumber: String? = nil, avatarURL: URL? = nil) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.avatarURL = avatarURL
    }
}

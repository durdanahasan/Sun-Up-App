import Foundation

public struct KitContent: Codable, Equatable, Sendable {
    public let name: String
    public let quantity: Int

    public init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
    }
}

public struct Kit: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let name: String
    public let priceAED: Decimal
    public let peopleCount: Int
    public let contents: [KitContent]

    public init(id: UUID = UUID(), name: String, priceAED: Decimal, peopleCount: Int, contents: [KitContent]) {
        self.id = id
        self.name = name
        self.priceAED = priceAED
        self.peopleCount = peopleCount
        self.contents = contents
    }
}

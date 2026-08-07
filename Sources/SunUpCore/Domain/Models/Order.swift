import Foundation

public enum OrderStatus: String, Codable, CaseIterable, Sendable {
    case confirmed
    case preparing
    case onTheWay = "on_the_way"
    case delivered

    public var displayName: String {
        switch self {
        case .confirmed: "Order confirmed"
        case .preparing: "Preparing your kit"
        case .onTheWay: "On the way"
        case .delivered: "Delivered to spot"
        }
    }
}

public enum PaymentMethod: String, Codable, CaseIterable, Sendable {
    case applePay = "apple_pay"
    case cash
    case card
}

public struct OrderItem: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let kit: Kit
    public let quantity: Int

    public init(id: UUID = UUID(), kit: Kit, quantity: Int) {
        self.id = id
        self.kit = kit
        self.quantity = quantity
    }

    public var subtotal: Decimal { kit.priceAED * Decimal(quantity) }
}

public struct Runner: Codable, Equatable, Sendable {
    public let name: String
    public let phoneNumber: String
    public let transport: String
    public let rating: Double

    public init(name: String, phoneNumber: String, transport: String, rating: Double) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.transport = transport
        self.rating = rating
    }
}

public struct Order: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let reference: String
    public let userID: UUID
    public let beach: Beach
    public let items: [OrderItem]
    public var status: OrderStatus
    public let deliveryDate: Date
    public let phoneNumber: String
    public let note: String?
    public let paymentMethod: PaymentMethod
    public let deliveryFeeAED: Decimal
    public let runner: Runner?

    public init(id: UUID = UUID(), reference: String, userID: UUID, beach: Beach, items: [OrderItem], status: OrderStatus, deliveryDate: Date, phoneNumber: String, note: String? = nil, paymentMethod: PaymentMethod, deliveryFeeAED: Decimal = 0, runner: Runner? = nil) {
        self.id = id
        self.reference = reference
        self.userID = userID
        self.beach = beach
        self.items = items
        self.status = status
        self.deliveryDate = deliveryDate
        self.phoneNumber = phoneNumber
        self.note = note
        self.paymentMethod = paymentMethod
        self.deliveryFeeAED = deliveryFeeAED
        self.runner = runner
    }

    public var itemsTotalAED: Decimal { items.reduce(0) { $0 + $1.subtotal } }
    public var totalAED: Decimal { itemsTotalAED + deliveryFeeAED }
}

public struct CreateOrderRequest: Codable, Equatable, Sendable {
    public let beachID: UUID
    public let items: [OrderItem]
    public let deliveryDate: Date
    public let phoneNumber: String
    public let note: String?
    public let paymentMethod: PaymentMethod

    public init(beachID: UUID, items: [OrderItem], deliveryDate: Date, phoneNumber: String, note: String?, paymentMethod: PaymentMethod) {
        self.beachID = beachID
        self.items = items
        self.deliveryDate = deliveryDate
        self.phoneNumber = phoneNumber
        self.note = note
        self.paymentMethod = paymentMethod
    }
}

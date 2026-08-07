import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var beaches: [Beach] = []
    @Published var kits: [Kit] = []
    @Published var search = ""
    @Published var errorMessage: String?
    private let service: any BeachServiceProtocol

    init(service: any BeachServiceProtocol) { self.service = service }
    var filteredBeaches: [Beach] {
        search.isEmpty ? beaches : beaches.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }
    func load() async {
        do { async let beaches = service.fetchBeaches(); async let kits = service.fetchKits(); (self.beaches, self.kits) = try await (beaches, kits) }
        catch { errorMessage = error.localizedDescription }
    }
}

@MainActor
final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var errorMessage: String?
    private let service: any OrderServiceProtocol
    init(service: any OrderServiceProtocol) { self.service = service }
    func load() async { do { orders = try await service.fetchOrders() } catch { errorMessage = error.localizedDescription } }
}

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [AppNotification] = []
    private let service: any NotificationServiceProtocol
    init(service: any NotificationServiceProtocol) { self.service = service }
    func load() async { notifications = (try? await service.fetchNotifications()) ?? [] }
}

@MainActor
final class CheckoutViewModel: ObservableObject {
    @Published var quantities: [UUID: Int] = [:]
    @Published var selectedTime = "Now (15 min)"
    @Published var phoneNumber = "+994"
    @Published var note = ""
    @Published var paymentMethod: PaymentMethod = .applePay
    @Published var createdOrder: Order?
    @Published var errorMessage: String?
    let beach: Beach
    let kits: [Kit]
    private let service: any OrderServiceProtocol

    init(beach: Beach, kits: [Kit], service: any OrderServiceProtocol) {
        self.beach = beach; self.kits = kits; self.service = service
        if let first = kits.first { quantities[first.id] = 1 }
    }
    var items: [OrderItem] { kits.compactMap { kit in let quantity = quantities[kit.id, default: 0]; return quantity > 0 ? .init(kit: kit, quantity: quantity) : nil } }
    var total: Decimal { items.reduce(0) { $0 + $1.subtotal } }
    var canCheckout: Bool { !items.isEmpty && phoneNumber.count >= 7 }
    func change(_ kit: Kit, by amount: Int) { quantities[kit.id] = max(0, quantities[kit.id, default: 0] + amount) }
    func submit() async {
        guard canCheckout else { return }
        let date = selectedTime.hasPrefix("Now") ? Date().addingTimeInterval(900) : Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        do { createdOrder = try await service.createOrder(.init(beachID: beach.id, items: items, deliveryDate: date, phoneNumber: phoneNumber, note: note.isEmpty ? nil : note, paymentMethod: paymentMethod)) }
        catch { errorMessage = error.localizedDescription }
    }
}

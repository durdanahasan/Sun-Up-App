import Foundation

public enum MockData {
    public static let userID = UUID(uuidString: "6D117F42-8838-466D-ACCC-6886FB6E3E74")!
    public static let jbrID = UUID(uuidString: "1155B78F-1393-4AC6-9D1D-C3092DB1B1BF")!
    public static let kiteID = UUID(uuidString: "E2786982-359E-4380-B3F8-49EC91218EED")!
    public static let dubaiBeachID = UUID(uuidString: "9C73BB4F-BD94-43A6-9032-035B25F7405F")!
    public static let standardKitID = UUID(uuidString: "243F67D9-299B-45E3-85DA-9EB829DCE6C3")!
    public static let dualKitID = UUID(uuidString: "CFCDBF5F-ACAB-44E0-897C-311769C32676")!

    public static let user = User(id: userID, fullName: "Durdana Hasan", email: "durdanahasanova@gmail.com", phoneNumber: "+994 50 555 0101")

    public static let beaches = [
        Beach(id: jbrID, name: "JBR Beach", coordinate: .init(latitude: 25.0760, longitude: 55.1310), distanceKilometers: 1.2, deliveryMinutes: 15, rating: 4.8, imageName: "jbr-beach"),
        Beach(id: kiteID, name: "Kite Beach", coordinate: .init(latitude: 25.1613, longitude: 55.2088), distanceKilometers: 3.4, deliveryMinutes: 20, rating: 4.9, imageName: "kite-beach"),
        Beach(id: dubaiBeachID, name: "Dubai Beach", coordinate: .init(latitude: 25.2026, longitude: 55.2397), distanceKilometers: 5.1, deliveryMinutes: 25, rating: 4.7, imageName: "dubai-beach")
    ]

    public static let kits = [
        Kit(id: standardKitID, name: "Standard Kit", priceAED: 30, peopleCount: 1, contents: [.init(name: "Umbrella", quantity: 1), .init(name: "Mat", quantity: 1), .init(name: "Towel", quantity: 1)]),
        Kit(id: dualKitID, name: "Dual Kit", priceAED: 50, peopleCount: 2, contents: [.init(name: "Umbrella", quantity: 1), .init(name: "Mat", quantity: 2), .init(name: "Towel", quantity: 2)])
    ]

    public static let runner = Runner(name: "Karim", phoneNumber: "+971 50 555 0142", transport: "Scooter", rating: 4.9)

    public static let orders = [
        Order(reference: "SU-8579", userID: userID, beach: beaches[0], items: [.init(kit: kits[0], quantity: 1), .init(kit: kits[1], quantity: 1)], status: .delivered, deliveryDate: Date().addingTimeInterval(-86_400), phoneNumber: "+994 50 555 0101", paymentMethod: .card, runner: runner),
        Order(reference: "SU-1042", userID: userID, beach: beaches[1], items: [.init(kit: kits[0], quantity: 1)], status: .onTheWay, deliveryDate: Date().addingTimeInterval(900), phoneNumber: "+994 50 555 0101", note: "Near the blue umbrella", paymentMethod: .cash, deliveryFeeAED: 5, runner: runner)
    ]

    public static let notifications = [
        AppNotification(kind: .order, title: "Your kit is on the way", message: "Order SU-1051 is out for delivery to JBR Beach", createdAt: Date().addingTimeInterval(-600)),
        AppNotification(kind: .promotion, title: "Weekend offer", message: "Get 15% off your next Dual Kit booking — this weekend only", createdAt: Date().addingTimeInterval(-3_600)),
        AppNotification(kind: .welcome, title: "Welcome to SUN UP", message: "Your account is ready. Order your first beach kit anytime.", createdAt: Date().addingTimeInterval(-172_800), isRead: true)
    ]
}
